mod point;

use point::{Angle, Point};
use regex::Regex;
use std::collections::{HashMap, HashSet};
use std::env;
use std::process;

#[derive(Debug)]
enum MeasureKind {
    Distance,
    Height,
    Angle,
}

#[derive(Debug)]
struct Measure {
    name: String,
    kind: MeasureKind,
    a: usize,
    b: usize,
}

impl Measure {
    fn value(&self, points: &[Point]) -> f64 {
        let a = &points[self.a];
        let b = &points[self.b];
        match self.kind {
            MeasureKind::Distance => a.distance(*b),
            MeasureKind::Height => (b.z() - a.z()).abs(),
            MeasureKind::Angle => {
                let cross = a.x() * b.y() - a.y() * b.x();
                let dot = a.x() * b.x() + a.y() * b.y();
                Angle::atan2(cross.abs(), dot).turns()
            }
        }
    }
}

#[derive(Debug, Clone, Copy)]
struct Connection {
    a: usize,
    b: usize,
    rest_len: f64,
}

#[derive(Debug)]
struct Tensegrity {
    gravity: f64,
    steps: usize,
    damping: f64,
    settle: f64,
    points: Vec<Point>,
    point_names: Vec<String>,
    connections: Vec<Connection>,
    measures: Vec<Measure>,
}

impl Tensegrity {
    fn parse(input: &str) -> Tensegrity {
        const NUM: &str = r"[-+]?\d*\.?\d+";

        let gravity_re = Regex::new(&format!(r"^gravity\s+({NUM})$")).unwrap();
        let steps_re = Regex::new(r"^steps\s+(\d+)$").unwrap();
        let damping_re = Regex::new(&format!(r"^damping\s+({NUM})$")).unwrap();
        let settle_re = Regex::new(&format!(r"^settle\s+({NUM})$")).unwrap();
        let point_re = Regex::new(&format!(
            r"^point\s+(\w+)\s*=\s*\(\s*({NUM})\s*,\s*({NUM})\s*,\s*({NUM})\s*\)$"
        ))
        .unwrap();
        let polar_re = Regex::new(&format!(
            r"^point\s+(\w+)\s*=\s*r:\s*({NUM})\s+theta:\s*({NUM})\s+z:\s*({NUM})$"
        ))
        .unwrap();
        let conn_re = Regex::new(r"^(string|stick)\s+(\w+)\s+(\w+)$").unwrap();
        let measure_re =
            Regex::new(r"^measure\s+(\w+)\s*=\s*(distance|height|angle)\s+(\w+)\s+(\w+)$").unwrap();

        let mut gravity = 0.0;
        let mut steps = 10_000;
        let mut damping = 10.0;
        let mut settle = 0.0001;
        let mut points = Vec::<Point>::new();
        let mut point_names = Vec::<String>::new();
        let mut connections = Vec::<Connection>::new();
        let mut name_to_point_idx = HashMap::<String, usize>::new();
        let mut measures = Vec::<Measure>::new();
        let mut measure_names = HashSet::<String>::new();

        fn lookup(name_to_point_idx: &HashMap<String, usize>, line: &str, name: &str) -> usize {
            *name_to_point_idx
                .get(name)
                .unwrap_or_else(|| panic!("Unknown point '{name}' in:\n{line}"))
        }

        fn parse_num(line: &str, num: &str) -> f64 {
            match num.parse::<f64>() {
                Ok(n) => n,
                Err(_) => panic!("Could not parse number '{num}' in:\n{line}"),
            }
        }

        fn parse_int(line: &str, num: &str) -> usize {
            match num.parse::<usize>() {
                Ok(n) => n,
                Err(_) => panic!("Could not parse integer '{num}' in:\n{line}"),
            }
        }

        for line in input.lines() {
            let line = line.trim();
            if line.is_empty() || line.starts_with('#') {
                continue; // allow blank lines and # comments
            }

            if let Some(c) = gravity_re.captures(line) {
                gravity = parse_num(line, &c[1]);
                if gravity != 0.0 {
                    panic!("Gravity poorly implemented");
                }
            } else if let Some(c) = steps_re.captures(line) {
                steps = parse_int(line, &c[1]);
            } else if let Some(c) = damping_re.captures(line) {
                damping = parse_num(line, &c[1]);
                if damping == 0.0 {
                    panic!("Damping must be nonzero (we divide by it) in:\n{line}");
                }
            } else if let Some(c) = settle_re.captures(line) {
                settle = parse_num(line, &c[1]);
            } else if let Some(c) = point_re.captures(line) {
                let name = c[1].to_string();
                if name_to_point_idx
                    .insert(name.clone(), points.len())
                    .is_some()
                {
                    panic!("Duplicate point name '{name}' in:\n{line}");
                }
                points.push(Point::cartesian(
                    parse_num(line, &c[2]),
                    parse_num(line, &c[3]),
                    parse_num(line, &c[4]),
                ));
                point_names.push(name);
            } else if let Some(c) = polar_re.captures(line) {
                let name = c[1].to_string();
                if name_to_point_idx
                    .insert(name.clone(), points.len())
                    .is_some()
                {
                    panic!("Duplicate point name '{name}' in:\n{line}");
                }
                points.push(Point::polar(
                    parse_num(line, &c[2]),
                    Angle::new(parse_num(line, &c[3])),
                    parse_num(line, &c[4]),
                ));
                point_names.push(name);
            } else if let Some(c) = conn_re.captures(line) {
                let a = lookup(&name_to_point_idx, line, &c[2]);
                let b = lookup(&name_to_point_idx, line, &c[3]);
                let rest_len = match &c[1] {
                    "string" => 0.0,
                    "stick" => points[a].distance(points[b]),
                    _ => unreachable!("regex guarantees kind is 'string' or 'stick'"),
                };
                connections.push(Connection { a, b, rest_len });
            } else if let Some(c) = measure_re.captures(line) {
                measures.push(Measure {
                    name: {
                        let name = c[1].to_string();
                        if !measure_names.insert(name.clone()) {
                            panic!("Duplicate measure name '{name}' in:\n{line}");
                        }
                        name
                    },
                    kind: match &c[2] {
                        "distance" => MeasureKind::Distance,
                        "height" => MeasureKind::Height,
                        "angle" => MeasureKind::Angle,
                        _ => unreachable!("regex guarantees kind is 'distance' or 'height'"),
                    },
                    a: lookup(&name_to_point_idx, line, &c[3]),
                    b: lookup(&name_to_point_idx, line, &c[4]),
                });
            } else {
                panic!("Invalid line:\n{line}");
            }
        }

        Tensegrity {
            gravity,
            steps,
            damping,
            settle,
            points,
            point_names,
            connections,
            measures,
        }
    }

    fn step(&mut self) -> f64 {
        let rate = 1.0 / self.damping;
        let mut forces = vec![Point::zero(); self.points.len()];

        for c in &self.connections {
            let disp = self.points[c.b] - self.points[c.a];
            let len = self.points[c.a].distance(self.points[c.b]);
            let force = if len > 1e-9 {
                disp * ((len - c.rest_len) / len)
            } else {
                Point::zero()
            };
            forces[c.a] += force;
            forces[c.b] -= force;
        }

        for force in &mut forces {
            *force += Point::cartesian(0.0, 0.0, -self.gravity);
        }

        let mut total_movement = 0.0;
        for (point, force) in self.points.iter_mut().zip(forces.iter().copied()) {
            let old_point = *point;
            *point += force * rate;
            if point.z() < 0.0 {
                // There's a floor
                *point = Point::cartesian(point.x(), point.y(), 0.0);
            }
            total_movement += point.distance(old_point);
        }
        total_movement
    }

    /// Run until the structure settles (total per-step movement drops below
    /// `settle`) or `steps` is reached, whichever comes first. Returns the
    /// number of steps actually taken.
    fn run(&mut self) -> usize {
        for i in 0..self.steps {
            let moved = self.step();
            if moved < self.settle {
                return i + 1;
            }
        }
        self.steps
    }

    fn report(&self) {
        println!();
        for (i, p) in self.points.iter().enumerate() {
            println!("point {} = {p}", self.point_names[i]);
        }

        println!();
        for c in &self.connections {
            let kind = if c.rest_len == 0.0 { "string" } else { "stick" };
            let len = self.points[c.a].distance(self.points[c.b]);
            println!(
                "{kind} {} {} length {:.5}",
                self.point_names[c.a], self.point_names[c.b], len
            );
        }

        println!();
        for m in &self.measures {
            println!("measure {} = {:.5}", m.name, m.value(&self.points));
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("usage: {} <input-file>", args[0]);
        process::exit(1);
    }

    let input = match std::fs::read_to_string(&args[1]) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("error: could not read '{}': {}", args[1], e);
            process::exit(1);
        }
    };

    let mut tensegrity = Tensegrity::parse(&input);
    let num_steps = tensegrity.run();
    println!("Finished after {num_steps} steps");
    tensegrity.report();
}
