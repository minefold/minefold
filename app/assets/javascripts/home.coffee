#= require raphael

# TODO Move this to the bottom of the page.

# l = -> console.log.apply(console, arguments)
#
# $ ->
#   c = $('#illin')
#   paper = Raphael(c[0], 960, 1000)
#
#
#   signWidth = 60 + 20 + 60 + 20 + 60
#
#   paper.rect(710, 40, 200, 220)
#     .attr(fill: '#012', stroke: 'none')
#
#   # sign
#   paper.path("M700 20 l#{signWidth} -10 l5 60 l-#{signWidth + 10} 0Z")
#     .attr(stroke: 'none')
#     .attr(fill: '#67422C')
#
#   # left peg
#   paper.path("M700 70 l20 0 l-5 200 l-35 -5Z")
#     .attr(stroke: 'none')
#     .attr(fill: '#67422C')
#
#   # right peg
#   paper.path("M#{signWidth + 680} 70 l20 0 l10 200 l-25 5Z")
#     .attr(stroke: 'none')
#     .attr(fill: '#67422C')
#
#   rightArm = paper.rect(100, 300, 40, 120).
#     attr(fill: 'turquoise', stroke: 'none')
#
#   leftArm = paper.rect(100, 300, 40, 120)
#
#
#   armSchwing = Raphael.animation {translate: 'r0'}, 1000, '<>'
#
#   armSchwing.percents.unshift 50
#   armSchwing.anim[50] = {easing: '<>', translate: 'r90'}
#
#   # armSchwingAnim.
#   l armSchwing
#
#   # rightArm.animate()
#   rightArm.animate(armSchwing)
#
#   # leftArm.animate armSchwingUp
#
