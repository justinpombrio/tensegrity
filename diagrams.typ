#import "@preview/cetz:0.3.0": draw, canvas

#let cred = rgb("#d31")
#let cblue = rgb("#09b")
#let cyellow = rgb("#b91")

#let turns(t) = t * 360deg

#let dot(pos, color: black) = {
  draw.circle(pos, radius: 0.02, stroke: color, fill: color)
}

#let segment(pos0, pos1, color: black) = {
  draw.line(pos0, pos1, stroke: color)
  dot(pos0, color: color)
  dot(pos1, color: color)
}

#let cis(a) = (calc.cos(a), calc.sin(a))

#let avg(pos0, pos1) = (
  (pos0.at(0) + pos1.at(0))/2,
  (pos0.at(1) + pos1.at(1))/2
)

// Rotate all angles by 1/24 for things to line up nicely
#let angle_offset = turns(1/24)
// The angle of rotation of the top of a layer relative to the bottom
#let angle_bot_to_top = turns(5/12)
// The angle of one layer compared to the previous layer
#let angle_layer = turns(3/12)

// Three lower sticks
#let a0 = cis(angle_offset)
#let b0 = cis(angle_offset + turns(1/3))
#let c0 = cis(angle_offset + turns(2/3))
#let a1 = cis(angle_offset + angle_bot_to_top)
#let b1 = cis(angle_offset + angle_bot_to_top + turns(1/3))
#let c1 = cis(angle_offset + angle_bot_to_top + turns(2/3))

// Three upper sticks
#let d0 = cis(angle_offset + angle_layer)
#let e0 = cis(angle_offset + angle_layer - turns(1/3))
#let f0 = cis(angle_offset + angle_layer - turns(2/3))
#let d1 = cis(angle_offset + angle_layer - angle_bot_to_top)
#let e1 = cis(angle_offset + angle_layer - angle_bot_to_top - turns(1/3))
#let f1 = cis(angle_offset + angle_layer - angle_bot_to_top - turns(2/3))
