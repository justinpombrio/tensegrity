use std::fmt;
use std::ops::{Add, AddAssign, Mul, Sub, SubAssign};

#[derive(Debug, Clone, Copy)]
pub struct Angle(f64);

impl Angle {
    pub fn new(turns: f64) -> Angle {
        Angle(turns)
    }

    pub fn atan2(y: f64, x: f64) -> Angle {
        Angle(y.atan2(x) / std::f64::consts::TAU)
    }

    pub fn turns(self) -> f64 {
        self.0
    }

    pub fn cos(self) -> f64 {
        self.radians().cos()
    }

    pub fn sin(self) -> f64 {
        self.radians().sin()
    }

    fn radians(self) -> f64 {
        self.0 * std::f64::consts::TAU
    }
}

impl fmt::Display for Angle {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{:.5}", self.0.rem_euclid(1.0))
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Point(f64, f64, f64);

impl Point {
    pub fn x(self) -> f64 {
        self.0
    }

    pub fn y(self) -> f64 {
        self.1
    }

    pub fn z(self) -> f64 {
        self.2
    }

    pub fn zero() -> Point {
        Point(0.0, 0.0, 0.0)
    }

    pub fn cartesian(x: f64, y: f64, z: f64) -> Point {
        Point(x, y, z)
    }

    pub fn polar(r: f64, theta: Angle, z: f64) -> Point {
        Point(r * theta.cos(), r * theta.sin(), z)
    }

    pub fn distance_sq(self: Point, other: Point) -> f64 {
        let dx = self.0 - other.0;
        let dy = self.1 - other.1;
        let dz = self.2 - other.2;
        dx * dx + dy * dy + dz * dz
    }

    pub fn distance(self: Point, other: Point) -> f64 {
        self.distance_sq(other).sqrt()
    }

    /*
    pub fn center_xy(points: &mut [Point]) {
        if points.is_empty() {
            return;
        }
        let mut n = 0.0;
        let mut sum_x = 0.0;
        let mut sum_y = 0.0;
        for p in points.iter() {
            sum_x += p.0;
            sum_y += p.1;
            n += 1.0;
        }
        let (center_x, center_y) = (sum_x / n, sum_y / n);
        for p in points.iter_mut() {
            p.0 -= center_x;
            p.1 -= center_y;
        }
    }
    */
}

impl Sub for Point {
    type Output = Point;
    fn sub(self, other: Point) -> Point {
        Point(self.0 - other.0, self.1 - other.1, self.2 - other.2)
    }
}

impl Add for Point {
    type Output = Point;
    fn add(self, other: Point) -> Point {
        Point(self.0 + other.0, self.1 + other.1, self.2 + other.2)
    }
}

impl AddAssign for Point {
    fn add_assign(&mut self, other: Point) {
        self.0 += other.0;
        self.1 += other.1;
        self.2 += other.2;
    }
}

impl SubAssign for Point {
    fn sub_assign(&mut self, other: Point) {
        self.0 -= other.0;
        self.1 -= other.1;
        self.2 -= other.2;
    }
}

impl Mul<f64> for Point {
    type Output = Point;
    fn mul(self, s: f64) -> Point {
        Point(self.0 * s, self.1 * s, self.2 * s)
    }
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let r = (self.0 * self.0 + self.1 * self.1).sqrt();
        let theta = Angle::atan2(self.1, self.0);
        write!(f, "r:{:.5}, theta:{}, z:{:.5}", r, theta, self.2)
    }
}
