#import "diagrams.typ": *

#set page(columns: 2)
#show link: underline

= Tensegrity Tower

These are plans for a tensegrity tower, following the pattern of the
#link("https://ropesandpoles.blogspot.com/2006/03/step-by-step-tensegrity-tower-part-1.html")[
Needle Point Tower]
at the Hirshhorn Museum, but with all layers being the same size.

== Mathematical Preliminaries

All angles are measured in turns.

The distance between two points on the surface of a cylinder is given by:

$l^2 = Delta h^2 + 2r^2(1 - cos(Delta alpha))$

where $l$ is the distance, $Delta h$ is the difference in height between the two
points, $r$ is the radius of the cylinder, and $Delta alpha$ is the difference
in angle between the two points.

== Layout

Looking from above, each layer of sticks makes a triangle with bits sticking
out. Each layer is a mirror of the layer below (it twists in the opposite
direction). According to the thesis #link("https://nexp.pt/pdf/tenseg.pdf")[A
Practical Guide to Tensegrity Design], the unique correct rotation of the tops
of the sticks relative to the bottoms of the sticks (the change of $theta$ in
polar coords) is 5/12. We'll re-derive that later.

In a single layer of the tower, there are three sticks. The bottoms of the
sticks lie on an equilateral triangle, and the tops of the sticks on another
equilateral triangle that's twisted compared to the first. Viewed from above:

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1, style: sstick)
  segment(b0, b1, style: sstick)
  segment(c0, c1, style: sstick)

  segment(a0, b0, style: sblue)
  segment(b0, c0, style: sblue)
  segment(c0, a0, style: sblue)

  segment(a1, b1, style: syellow)
  segment(b1, c1, style: syellow)
  segment(c1, a1, style: syellow)

  dot(c0, style: sred)
  dot(c1, style: sred)
  circlearc(turns(-7/24), turns(3/24), style: sred)
})

The dotted red arc shows the _twist_ of a layer: the rotation of the top
triangle relative to the bottom triangle. This is an important angle, and we'll
call it $theta$.

That's one layer. Each further layer of the tower is rotated and reflected
compared to the layer below, such that the bottoms of the sticks of one layer
and the tops of the sticks of the layer below it, when viewed from above, form a
regular hexagon:

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1, style: sstick)
  segment(b0, b1, style: sstick)
  segment(c0, c1, style: sstick)

  segment(d0, d1, style: sblue)
  segment(e0, e1, style: sblue)
  segment(f0, f1, style: sblue)

  segment(a1, d0, style: syellow)
  segment(d0, c1, style: syellow)
  segment(c1, e0, style: syellow)
  segment(e0, b1, style: syellow)
  segment(b1, f0, style: syellow)
  segment(f0, a1, style: syellow)

  segment(c1, e0, style: sred)
  segment(e0, b1, style: sred)
  segment(b1, c1, style: sred)
})

There's an overlap in height between any two layers, thus this red dotted
triangle---connecting the tops of two sticks in one layer and the bottom of a
stick in the layer above---is not flat. The _incline_ of this plane (the angle
you'd need to rotate it to make it flat) is an important angle, and we'll call
it $phi$.

=== Degrees of Freedom

We can use degrees of freedom to calculate the number of strings required for
the tower.

_A completed tower must have exactly 6 degrees of freedom (3 translational and 3
rotational). Each stick starts with 5 degrees of freedom (3 translational and 2
rotational). There are three sticks per layer. Each string eliminates one degree
of freedom of motion, so if $m$ is the total number of strings, then $5*3n-m=6$,
so $m = 15n - 6$._

Some more counting will tell us how many string ends must come out of each
stick.

_Call the number of string-ends $m'$. There are two string-ends per string, so
$m' = 2m$. Call the number of stick-ends $p$. There are two stick-ends per stick
and three sticks per layer, so $p = 6n$. Putting these together, we have $m' =
2m = 30n - 12 = 30(p/6) -12 = 5p - 12$. So there are 5 strings coming out of
each end of a stick, less 12 string-ends._

Those 12 missing string-ends turn out to be from the bottom-most and top-most
layer, which have 4 string-ends per stick, compared to the 5 string-ends
everywhere else.

=== Definitions

A couple variables to represent counts:

- $n$ is the number of layers (so there are $3n$ sticks).
- $m = 15n-6$ is the total number of strings.

There are four measurement parameters that determine the shape of the tower:

- $r$ is the radius of the cylinder circumscribing the tower.
- $h$ is the height from the bottom of each stick to the top.
- $theta$ is the _twist_ of a layer: the rotation of the equilateral triangle
  formed by the tops of the sticks of a layer, relative to the triangle formed
  by the bottoms of those sticks. (See the first diagram in "Layout".)
- $phi$ is _incline_ of a triangle formed by the tops of two sticks of a
  layer and the bottom of the bottom of the stick in the layer above that lies
  between them. (See the second diagram in "Layout".)

From these four parameters you can compute:

- $d$ is the dip from one layer of the tower to the next (that is, the change in
  height from the bottom of a layer to the top of the layer below it).

== Measurements

There are sticks, plus four kinds of strings:
- _Sticks_ of length $s$ are grouped in layers, three sticks per layer.
- _Triangular Strings_ of length $t$ form a triangle at the very top and bottom
  of the tower.
- _Hexagonal Strings_ of length $x$ form wobbly hexagons at the intersections
  between layers.
- _Within-Layer Spinal Strings_ of length $w$ go from the bottom of a stick in a
  layer to the top of a different stick in the same layer.
- _Between-Layer Spinal Strings_ of length $b$ go between sticks of different
  layers.

(See the helpful diagram on page 22 of
#link("http://kennethsnelson.net/Tensegrity_and_Weaving.pdf")[Tensegrity and
Weaving].)

=== Sticks

Let's measure the length $s$ of one of the sticks. A stick has change in height
$h$ and change in angle $theta$. Using the cylindrical distance formula from
"Preliminaries" we get a length of:

$s^2 = h^2 + 2r^2(1 - cos(theta))$

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1, style: sblue)
  segment(b0, b1)
  segment(c0, c1)
})

=== Triangular Strings

There are strings of length $t$ forming a triangle at the very bottom and very
top of the tower:

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  segment(a0, b0, style: sblue)
  segment(b0, c0, style: sblue)
  segment(c0, a0, style: sblue)

  circlearc(turns(-7/24), turns(1/24), style: sred)
})

The change in height of one of these strings is 0, and the change in angle is
1/3 (it's an equilateral triangle), so the distance formula gives:

$t^2 = 2r^2(1 - cos(1/3)) = 3r^2$

=== Hexagonal Strings

There are strings of length $x$ connecting the top of one layer to the bottom of
the next, forming a wobbly hexagon.

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  line(d0, d1)
  line(e0, e1)
  line(f0, f1)

  segment(a1, d0, style: sblue)
  segment(d0, c1, style: sblue)
  segment(c1, e0, style: sblue)
  segment(e0, b1, style: sblue)
  segment(b1, f0, style: sblue)
  segment(f0, a1, style: sblue)

  circlearc(turns(-5/24), turns(-1/24), style: sred)
})

The change in height is $d$ and the change in angle is 1/6, so the length of an
edge of the hexagon is:

$x^2 = d^2 + 2r^2(1 - cos(1/6)) = d^2 + r^2$

What's $d$, though, in terms of $phi$? Phi is the incline of this dashed yellow
triangle, while $d$ is the height of that triangle:

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  line(d0, d1)
  line(e0, e1)
  line(f0, f1)

  segment(a1, d0, style: sblue)
  segment(d0, c1, style: sblue)
  segment(c1, e0, style: sblue)
  segment(e0, b1, style: sblue)
  segment(b1, f0, style: sblue)
  segment(f0, a1, style: sblue)

  segment(c1, e0, style: syellow)
  segment(e0, b1, style: syellow)
  segment(c1, b1, style: syellow)
  segment(avg(c1, b1), e0, style: sred)
})

The triangle perpendicular (the dotted red line) has length $r/2$ when viewed
from above and length $d$ when viewed from the side, so:

$tan(phi) = d/((r/2))$

$d = 1/2 r tan(phi)$

Putting these equations together yields:

$x^2 = 1/4 r^2 tan(phi)^2 + r^2$

=== Within-Layer Spinal Strings

Each layer has three vertical-ish strings of length $w$ going from the bottom of
its sticks to the tops of other sticks:

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  segment(a0, c1, style: sblue)
  segment(b0, a1, style: sblue)
  segment(c0, b1, style: sblue)

  circlearc(turns(-7/24), turns(3/24), style: sred)
})

The red arc has angle $theta$ (since it goes between the bottom and top of a
stick). It also has angle $1/3 + alpha$ where $alpha$ is the change in angle of
a within-layer spinal string. So $theta = 1/3 + alpha$ and $alpha = theta -
1/3$.

Thus a within-layer spinal string has change in angle $theta - 1/3$ and change
in height $h$. Using the cylindrical distance formula it has length:

$w^2 = h^2 + 2r^2(1 - cos(theta - 1/3))$

=== Between-Layer Spinal Strings

There are also vertical-ish strings of length $b$ going between layers: from the
bottom of a stick to the bottoms of the sticks above and below it, and likewise
for the tops of sticks:

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  segment(d0, d1, style: sblue)
  segment(e0, e1, style: sblue)
  segment(f0, f1, style: sblue)

  segment(a0, d0, style: syellow)
  segment(b0, f0, style: syellow)
  segment(c0, e0, style: syellow)

  circlearc(turns(-7/24), turns(3/24), style: sred)
})

The dotted red arc has length $theta$. It also has length $beta + 1/6$, where
$beta$ is the change in angle of a between-layer string. So $theta = beta + 1/6$
and $beta = theta - 1/6$.

Thus a between-layer spinal string has change in angle $theta - 1/6$ and change
in height $h - d$. Using the cylindrical distance formula it has length:

$b^2 = (h-d)^2 + 2r^2(1 - cos(theta - 1/6))$

=== Summary

/ stick: $s^2 = h^2 + 2r^2(1 - cos(theta))$
/ triangle: $t^2 = 3r^2$
/ hexagon: $x^2 = d^2 + r^2$
/ dip: $d = 1/2 r tan(phi)$
/ within-layer: $w^2 = h^2 + 2r^2(1 - cos(theta - 1/3))$
/ between-layer: \ $b^2 = (h-d)^2 + 2r^2(1 - cos(theta - 1/6))$

== Calculating the Shape

=== Single-Layer Contortion

Pick $theta$ to minimize $w$ given the constraints:

- $s^2 = h^2 + 2r^2(1 - cos(theta))$

- $w^2 = h^2 + 2r^2(1 - cos(theta - 1/3))$

Rearranging, we want to minimize:

$w^2 = s^2 + 2r^2(cos(theta) - cos(theta - 1/3)$

The minima will be where the derivative of $w^2$ is 0:

$d/(d theta) w^2 = 4 pi r^2(sin(theta - 1/3) -sin(theta)) = 0$

$sin(theta) = sin(theta - 1/3)$

The relevant solution to this equation is $theta = 5/12$. Substituting into the
measurements gives:

/ stick: $s^2 = h^2 + r^2(2 + sqrt(3))$
/ triangle: $t^2 = 3r^2$
/ hexagon: $x^2 = d^2 + r^2$
/ dip: $d = 1/2 r tan(phi)$
/ within-layer: $w^2 = h^2 + r^2(2 - sqrt(3))$
/ between-layer: $b^2 = (h-d)^2 + 2r^2$

#pagebreak()

=== Multi-Layer Contortion

Pick $phi$ to minimize $b$ given the constraints:

// - $s^2 = h^2 + r^2(2 + sqrt(3))$
// - $x^2 = d^2 + r^2$
- $d = 1/2 r tan(phi)$
- $b^2 = (h-d)^2 + 2r^2$

Expanding and substituting into the second equation:

$b^2 = h^2 - 2 h d + d^2 + 2r^2$

$b^2 = h^2 - h r tan(phi) + 1/4 r^2 tan(phi)^2 + 2r^2$

To minimize $b$, the derivative of $b^2$ with respect to $phi$ must be 0:

$ d/(d phi) b^2 = - (h r)/cos(phi)^2 + 1/2 r^2 sin(phi)/cos(phi)^3 = 0 $

Multiplying by $2cos(phi)^3/r$ and simplifying:

$ 2 h cos(phi) = r sin(phi) $

$ tan(phi) = (2 h)/ r $

---------

$b^2 = (h - 1/2 r tan(phi))^2 + 2r^2$

$b^2 = h^2 - h r tan(phi) + 1/4 r^2 tan(phi)^2 + 2r^2$

$d/(d phi) b^2 = - (h r)/cos(phi) + 1/2 r^2 sin(phi)/cos(phi)^3 = 0$

$- h cos(phi)^2 + 1/2 r sin(phi) = 0$

$2h/r cos(phi) = tan(0.666)$


=== OLD Summary

(No longer assuming $r = 1$, which scales all measurements up to this point by a
factor of $r$.)

- $s = sqrt(2 + sqrt(3) + (h/r)^2)r$
- $d = r/2$
- Triangular string length $= sqrt(3)r$
- Hexagonal string length $= sqrt(5)/2 r$
- Intra-layer spinal string length $= sqrt(2 - sqrt(3) + (h/r)^2) r$
- Inter-layer spinal string length $sqrt(2 + ((h-d)/r)^2) r$.

Picking $h = sqrt(3)r$:

- $s = sqrt(5 + sqrt(3))r$
- $d = r/2$
- Triangular string length $= sqrt(3)r$
- Hexagonal string length $= sqrt(5)/2 r$
- Intra-layer spinal string length $= sqrt(5 - sqrt(3))r$
- Inter-layer spinal string length $sqrt(2 + (sqrt(3)-1/2)^2) r =
  sqrt(21/4-sqrt(3)) r$.

If $s = 1219"mm"$:

- $s = 1219"mm"$
- $r = 470"mm"$
- $h = 814"mm"$
- $d = 235"mm"$
- Triangular string length $= 814"mm"$. Count of $6$ for $4.884"m"$.
- Hexagonal string length $= 525"mm"$. Count of $6(n-1) = 54$ for $28.350"m"$.
- Intra-layer spinal string length $= 849"mm"$. Count of $3n = 30$ for
  $25.470"m"$.
- Inter-layer spinal string length $= 881"mm"$. Count of $6(n-1) = 54$ for
  $47.574"m"$.

Total string count is 144, which matches the $m = 15n-6$ formula from the
degrees-of-freedom analysis at the start of the document.

Total string length is $106.278"m"$.

== Materials

/ Sticks: ✓ 30 x 4' long 3/4" diameter wooden dowels. Weight about 0.4 lb, for a
  total of 12 lb. Where does one get wood dowels? From
  #link("https://wood-dowel.com/dowel-rods/poplar-dowels/48-poplar-dowels/3-8-x-48-poplar-dowels.html")[wood-dowels.com]
  of course.
/ Bolts: ✓ 60 x 10-24" hanger bolts. The ones I prototyped with are 2" long in
  total, with 1" of screw, 5/8" of 3/16" (or 10-24?) bolt, and 3/8" blank in the middle.
  For the rest I'll get #link("https://www.mcmaster.com/90915A414/")[1" + 1"
  10-24 hanger bolts].
/ Nuts: ✓ 60 x 10-24 nuts. Getting
  #link("https://www.mcmaster.com/91841A011/")[these].
/ Washers: ✓ 288 washers, for either end of the strings. The ones I got for the
  prototype have a 6mm inner diameter, and are not very wide or thick. These
  #link("https://www.mcmaster.com/94773A743/")[expensive shims] have the perfect
  dimensions, but might not be strong enough. Here are
  #link("https://www.mcmaster.com/92141A030/")[cheap washers] that are quite
  large, but cheap  and strong. They might cut the cord though. So instead
  here's cheap, strong, and round
  #link("https://www.9km-outdoor.com/products/fishing-solid-ring-20-100pcs-fishing-lure-connectors-stainless-steel-snap-fishing-accessories-solid-ring-saltwater-tackle-chrome?variant=43111978238115")[fishing
  solid rings].
/ String: ✓ Need a total of $106.278"m"$ of string, though in practice a good deal
  more than that, maybe $150"m"$ for knot overhead, mistakes, etc. Fortunately
  we live in the future, so you can get
  #link("https://www.9km-outdoor.com/products/0-8-1-6mm-uhmwpe-cord-spectra-line-hollow-braided-uv-resistnce-outdoor-repair-spliceable-rope-for-spearfishing-stunt-kitesurfing?variant=43094583967907")[black
  1.6mm cord that's rated for 400lbs].
/ Paint: Paint or wood stain. Maybe deep red paint.
/ Protectant: Something to put over the paint to make it weather resistant.

#link("https://www.mcmaster.com/")[McMaster] has lots of specific hardware.

== String Construction

- Tie one end of a string to a metal ring using three half hitches.
- Weight the string with 50lb to tighten the first knot.
- Tie the other end of the string to another metal ring using three half
  hitches, at a slightly shorter length (see the next section).
- Weight the string again with 50lb to tighten the second knot.

== Jig Construction

Define the _actual length_ of a tied string to be the distance from the center
of one of the metal rings it's attached to to the center of the other. Define
the _nominal length_ of a string to be the measurements computed in this
document. Then:

- The actual length should be $3"mm"$ shorter than the nominal length.
- The K'nex jig's _measurement track_ should make a correctly sized string on it
  be taut. Emperically this happens when the distance between the _outsides_ of
  the rods sticking up (the longest measurement you might make) is $3"mm"$
  longer than the nominal length.
- The K'nex jig's _tying track_ should be two blue spacers shorter than the
  measurement track.

== Links

- #link("http://www.tensegriteit.nl/e-links.html")[Tensegrity links]
- #link("http://kennethsnelson.net/Tensegrity_and_Weaving.pdf")[Tower diagram
  (pg 22)]
- #link("https://ropesandpoles.blogspot.com/2006/03/step-by-step-tensegrity-tower-part-1.html")[Vague tutorial]
- #link("https://www.comsol.com/blogs/modeling-tensegrity-with-a-floating-table")[High
quality Needle Tower pic]
- #link("https://nexp.pt/pdf/tenseg.pdf")[Thesis on tensegrity math]
- #link("https://www.glassswing.com/tensegrity-tower-1")[Short glowy tensegrity
  tower]
- #link("https://photos1.blogger.com/blogger/3732/1264/1600/Needle%20Tower%200003.jpg")[Needle tower]

== Open Questions

- Is there one correct choice for $d$ relative to $h$, or can it be whatever?
  The failure mode would be a floppy tower because the sticks can settle into a
  lower-string-length configuration.
- How to tension final cords?
