exports.distance = (p1, p2) ->
  Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2))

exports.degToRad = (val) ->
  val / 180 * Math.PI
