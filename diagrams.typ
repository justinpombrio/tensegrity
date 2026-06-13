#import "@preview/cetz:0.3.0": draw, canvas

#let sdefault = (paint: black, thickness: 0.015)
#let sstick = (paint: black, thickness: 0.02)
#let sblue = (paint: rgb("#09b"), thickness: 0.015)
#let syellow = (paint: rgb("#b91"), dash: "densely-dashed", thickness: 0.02)
#let sred = (paint: rgb("#d31"), dash: "dotted", thickness: 0.03)

#let turns(t) = t * 360deg

#let dot(pos, style: sdefault) = {
  draw.circle(pos, radius: style.thickness, fill: style.paint, stroke: style.paint)
}

#let segment(pos0, pos1, style: sdefault) = {
  draw.line(pos0, pos1, stroke: style)
  dot(pos0, style: style)
  dot(pos1, style: style)
}

#let cis(a) = (calc.cos(a), calc.sin(a))

#let circlearc(start, stop, style: sdefault) = {
  draw.arc(
    cis(start),
    radius: 1,
    start: start,
    delta: (stop - start),
    stroke: style,
  )
}

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
