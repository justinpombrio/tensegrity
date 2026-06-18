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
    Radius,
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
            MeasureKind::Radius => (a.x() * b.x() + a.y() * b.y()).sqrt(),
            MeasureKind::Angle => {
                let cross = a.x() * b.y() - a.y() * b.x();
                let dot = a.x() * b.x() + a.y() * b.y();
                Angle::atan2(cross.abs(), dot).turns()
            }
        }
    }
}

#[derive(Debug, Clone, Copy)]
enum ConnectionKind {
    String,
    Stick,
    Spring,
}

#[derive(Debug, Clone, Copy)]
struct Connection {
    kind: ConnectionKind,
    a: usize,
    b: usize,
    init_len: f64,
}

impl Connection {
    fn force(&self, points: &[Point]) -> Point {
        let disp = points[self.b] - points[self.a];
        let len = points[self.a].distance(points[self.b]);
        let rest_len = self.init_len;
        match self.kind {
            ConnectionKind::Stick => disp * ((len - rest_len) / len),
            ConnectionKind::String => disp * ((len - rest_len).max(0.0) / len),
            ConnectionKind::Spring => disp,
        }
    }
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
        const NUM: &str = r"[-+]?\d*\.?\d+(?:/[-+]?\d*\.?\d+)?";

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
        let conn_re = Regex::new(r"^(string|spring|stick)\s+(\w+)\s+(\w+)$").unwrap();
        let measure_re =
            Regex::new(r"^measure\s+(\w+)\s*=\s*(distance|height|radius|angle)\s+(\w+)\s+(\w+)$")
                .unwrap();

        let mut gravity = 0.1;
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
            if let Some((n, d)) = num.split_once('/') {
                let n: f64 = n
                    .parse()
                    .unwrap_or_else(|_| panic!("Bad numerator '{n}' in:\n{line}"));
                let d: f64 = d
                    .parse()
                    .unwrap_or_else(|_| panic!("Bad denominator '{d}' in:\n{line}"));
                if d == 0.0 {
                    panic!("Division by zero in '{num}' in:\n{line}");
                }
                n / d
            } else {
                num.parse()
                    .unwrap_or_else(|_| panic!("Could not parse number '{num}' in:\n{line}"))
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
                let init_len = points[a].distance(points[b]);
                let kind = match &c[1] {
                    "spring" => ConnectionKind::Spring,
                    "stick" => ConnectionKind::Stick,
                    "string" => ConnectionKind::String,
                    _ => unreachable!("regex guarantees kind is 'string|stick|spring'"),
                };
                connections.push(Connection {
                    kind,
                    a,
                    b,
                    init_len,
                });
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
                        "radius" => MeasureKind::Radius,
                        "angle" => MeasureKind::Angle,
                        _ => {
                            unreachable!("regex guarantees kind is 'distance|height|radius|angle'")
                        }
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
        let effective_gravity = self.gravity / self.damping;
        let mut forces = vec![Point::zero(); self.points.len()];

        for connection in &self.connections {
            let force = connection.force(&self.points);
            forces[connection.a] += force;
            forces[connection.b] -= force;
        }

        for force in &mut forces {
            *force += Point::cartesian(0.0, 0.0, -effective_gravity);
        }

        for (point, force) in self.points.iter().zip(forces.iter_mut()) {
            if point.z() <= 0.0 && force.z() < 0.0 {
                *force = Point::cartesian(force.x(), force.y(), 0.0);
            }
        }

        let mut total_movement = 0.0;
        for (point, force) in self.points.iter_mut().zip(forces.iter().copied()) {
            let old_point = *point;
            *point += force * rate;
            if point.z() < 0.0 {
                // There's a floor
                //*point = Point::cartesian(point.x(), point.y(), 0.0);
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
        for (i, point) in self.points.iter().enumerate() {
            println!("point {} = {}", self.point_names[i], point);
        }

        println!();
        for c in &self.connections {
            let kind = match c.kind {
                ConnectionKind::Spring => "spring",
                ConnectionKind::String => "string",
                ConnectionKind::Stick => "stick",
            };
            let len = self.points[c.a].distance(self.points[c.b]);
            let stretch = len / c.init_len - 1.0;
            println!(
                "{kind} {} {} length {:.5} stretch {:.5} g {:.5}",
                self.point_names[c.a],
                self.point_names[c.b],
                len,
                stretch,
                stretch / self.gravity
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
