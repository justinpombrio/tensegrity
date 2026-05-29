#import "diagrams.typ": *

#set page(columns: 2)
#show link: underline

= Tensegrity Tower

Following the pattern of the
#link("https://ropesandpoles.blogspot.com/2006/03/step-by-step-tensegrity-tower-part-1.html")[
Needle Point Tower]
at the Hirshorn Museum, except without the extra large bottom layer.

_Note:_ all angles are measured in turns.

== Layout

Looking from above, each layer of sticks makes a triangle with bits sticking
out. Each layer is a mirror of the layer below (it twists in the opposite
direction). According to the thesis #link("https://nexp.pt/pdf/tenseg.pdf")[A
Practical Guide to Tensegrity Design], the unique correct rotation of the tops
of the sticks relative to the bottoms of the sticks (the change of $theta$ in
polar coords) is 5/12.

Here's the view from above of one layer in black, and the layer above in blue:

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  line(d0, d1, stroke: cblue)
  line(e0, e1, stroke: cblue)
  line(f0, f1, stroke: cblue)
})

=== Degrees of Freedom

A completed tower must have exactly 6 degrees of freedom (3 translational and 3
rotational). Each stick starts with 5 degrees of freedom (3 translational and 2
rotational). There are three sticks per layer. Each string eliminates one degree
of freedom of motion, so if $m$ is the total number of strings, then $5*3n-m=6$,
so $m = 15n - 6$.

Call the number of string-ends $m'$. There are two string-ends per string, so
$m' = 2m$.

Call the number of stick-ends $p$. There are two stick-ends per stick and three
sticks per layer, so $p = 6n$.

Putting these together, we have $m' = 2m = 30n - 12 = 30(p/6) -12 = 5p - 12$. So
there are 5 strings coming out of each end of a stick, except for the
bottom-most and top-most layers which have 4 strings per stick-end.

=== Definitions

- $n$ is the number of layers (so there are $3n$ sticks.
- $m = 15n-6$ is the total number of strings.
- $r = 1$ is the radius of the cylinder circumscribing the tower.
- $s$ is the length of each stick.
- $h$ is the height from the bottom of each stick to the top.
- $d$ is the dip from one layer of the tower to the next (that is, the change in
  height from the bottom of a layer to the top of the layer below it).

== Measurements

There are sticks, plus four kinds of strings:
- _Sticks_ are grouped in layers, three sticks per layer.
- _Triangular Strings_ form a triangle at the very top and bottom of the tower.
- _Hexagonal Strings_ form wobbly hexagons at the intersections between layers.
- _Inter-Layer Spinal Strings_ go from the bottom of a stick in a layer to the
  top of a different stick in the same layer.
- _Intra-Layer Spinal Strings_ go between sticks of different layers.

See the helpful diagram on page 22 of
#link("http://kennethsnelson.net/Tensegrity_and_Weaving.pdf")[Tensegrity and
Weaving].

=== Sticks

Let's measure the length of one of the sticks.

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1, color: cblue)
  segment(b0, b1)
  segment(c0, c1)

  segment((0, 0), avg(a0, a1), color: cred)
  segment((0, 0), a0, color: cred)
  segment(a0, avg(a0, a1), color: cred)
})

This triangle has an angle of $2.5/12$ turns, so the length of the blue line
when viewed from above is $2sin(5/24) = (1 + sqrt(3))/sqrt(2)$. The change in
height is $h$, giving a total length of $sqrt(((1 + sqrt(3))/sqrt(2))^2 + h^2) =
sqrt(2 + sqrt(3) + h^2)$.


=== Triangular Strings

There are strings forming a triangle at the very bottom and very top of the
tower:

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  segment(a0, b0, color: cblue)
  segment(b0, c0, color: cblue)
  segment(c0, a0, color: cblue)

  segment((0, 0), a0, color: cred)
  segment((0, 0), avg(a0, b0), color: cred)
  segment(a0, avg(a0, b0), color: cred)
})

This is a $1/12$, $2/12$, $3/12$ triangle, so each of these strings has length
$sqrt(3)$.

=== Hexagonal Strings

There are strings connecting the top of one layer to the bottom of the next,
forming a wobbly horizontal-ish hexagon.

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

  segment(a1, d0, color: cblue)
  segment(d0, c1, color: cblue)
  segment(c1, e0, color: cblue)
  segment(e0, b1, color: cblue)
  segment(b1, f0, color: cblue)
  segment(f0, a1, color: cblue)

  segment((0, 0), c1, color: cred)
  segment((0, 0), e0, color: cred)
  segment(c1, e0, color: cred)
})

This is an equilateral triangle, so the length of each hexagonal string when
viewed from above is 1. The change in height is $d$, so the total length is
$sqrt(1 + d^2)$.

The choice of $d$ isn't arbitrary, though. I'm not sure how to calculate it
precisely, but my best guess is that the horizontal and vertical displacements
of the bottom of a stick from the center point of the tops of the two sticks
supporting it should be equal.

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

  segment(a1, d0, color: cblue)
  segment(d0, c1, color: cblue)
  segment(c1, e0, color: cblue)
  segment(e0, b1, color: cblue)
  segment(b1, f0, color: cblue)
  segment(f0, a1, color: cblue)

  segment(b1, c1, color: cyellow)
  segment((0, 0), e0, color: cyellow)

  segment(e0, c1, color: cred)
  segment(c1, avg(b1, c1), color: cred)
  segment(e0, avg(b1, c1), color: cred)
})

This is a $1/12$, $2/12$, $3/12$ triangle, making my estimate $d = 1/2$. Making
the hexagonal string length be $sqrt(1 + d^2) = sqrt(5/4) = sqrt(5)/2$.

=== Intra-Layer Spinal Strings

Each layer has three vertical-ish strings going from the bottom of its sticks to
the tops of other sticks.

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  segment(a0, c1, color: cblue)
  segment(b0, a1, color: cblue)
  segment(c0, b1, color: cblue)

  segment((0, 0), avg(a0, c1), color: cred)
  segment((0, 0), a0, color: cred)
  segment(a0, avg(a0, c1), color: cred)
})

This triangle has angle 1/24, so the string when viewed from above has length
$2sin(1/24) = (sqrt(3)-1)/sqrt(2)$. The change in height is $h$, so the total
length is $sqrt(2 - sqrt(3) + h^2)$.

=== Inter-Layer Spinal Strings

There are also vertical-ish strings going between layers: from the bottom of a
stick to the bottoms of the sticks above and below it, and likewise for the tops
of sticks.

#canvas(length: 3cm, {
  import draw: *

  circle((0, 0), radius: 1)
  dot((0, 0))

  segment(a0, a1)
  segment(b0, b1)
  segment(c0, c1)

  segment(d0, d1, color: cblue)
  segment(e0, e1, color: cblue)
  segment(f0, f1, color: cblue)

  segment(a0, d0, color: cyellow)
  segment(b0, f0, color: cyellow)
  segment(c0, e0, color: cyellow)

  segment((0, 0), avg(c0, e0), color: cred)
  segment((0, 0), e0, color: cred)
  segment(e0, avg(c0, e0), color: cred)
})

This is an isosceles right triangle, so the yellow line (viewed from above) has
length $sqrt(2)$. The change in height is $h - d$, so the total length is
$sqrt(2 + (h-d)^2)$.

=== Summary

(No longer assuming $r = 1$, which scales all measurements up to this point by a
factor of $r$.)

- $s = sqrt(2 + sqrt(3) + (h/r)^2)r$
- $d = r/2$
- Triangular string length $= sqrt(3)r$
- Hexagonal string length $= sqrt(5)/2 r$
- Intra-layer spinal string length $= sqrt(2 - sqrt(3) + (h/r)^2) r$
- Inter-layer spinal string length $sqrt(2 + (h-d)^2) r$.

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
  $47.547"m"$.

Total string count is 144, which matches the $m = 15n-6$ formula from the
degrees-of-freedom analysis at the start of the document.

Total string length is $106.251"m"$.

== Materials

/ Sticks: 30 x 4' long 3/8" diameter wooden dowels. Weight about 0.4 lb, for a
  total of 12 lb. Where does one get wood dowels? From
  #link("https://wood-dowel.com/dowel-rods/poplar-dowels/48-poplar-dowels/3-8-x-48-poplar-dowels.html")[wood-dowels.com] of course.
/ Bolts: 60 x 3/16" hanger bolts. The ones I prototypes with are 2" long in
  total, with 1" of screw, 5/8" of 3/16" bolt, and 3/8" blank in the middle.
  For the rest I'll get #link("https://www.mcmaster.com/90915A410/")[7/8+5/8
  inch 10-24 hanger bolts].
/ Nuts: 60 x 3/16" nuts. Getting
  #link("https://www.mcmaster.com/91841A011/")[these].
/ Washers: About 300 washers, for either end of the strings. The ones I
  got for the prototype have a 6mm inner diameter, and are not very wide or thick.
  These #link("https://www.mcmaster.com/94773A743/")[expensive shims] have the
  perfect dimensions, but might not be strong enough. Here are
  #link("https://www.mcmaster.com/92141A030/")[cheap washers] that are quite
  large, but cheap  and strong.
/ String: Lacking a precise total string count, my eyeball says there are
  about 5 string-ends per stick-end on the Needle Tower. There are $30*2 = 60$
  stick-ends, making about $60*5 = 300$ string-ends. Two string-ends per string,
  so $150$ strings. Most are roughly 3-feet, giving rougly 450 feet of string.
  [My previous estimate was 200feet, something is off!] Fortunately we live in
  the future, so you can get
  #link("https://www.9km-outdoor.com/products/0-8-1-6mm-uhmwpe-cord-spectra-line-hollow-braided-uv-resistnce-outdoor-repair-spliceable-rope-for-spearfishing-stunt-kitesurfing?variant=43094583967907")[black
  1mm cord that's rated for 350lbs].
/ Paint: Paint or wood stain. Maybe deep red paint.
/ Protectant: Something to put over the paint to make it weather resistant.

#link("https://www.mcmaster.com/")[McMaster] has lots of specific hardware.

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
