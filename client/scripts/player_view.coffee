define ->
  (canvas, player) ->
    shieldColor = if player.invincible
      "rgb(255, 255, 0)"
    else
      "rgba(0, 160, 255, #{player.health.toFixed(2)})"

    canvas
      .translateCanvas
        translateX: player.position.x
        translateY: player.position.y
      .drawArc
        strokeStyle: shieldColor
        strokeWidth: 1
        radius: player.radius
        x: 0, y: 0
      .scaleCanvas
        x: 0, y: 0
        scaleX: player.radius
        scaleY: player.radius
      .drawLine
        rotate: player.direction
        fillStyle: player.color
        closed: true
        rounded: true
        x1: 0.9
        y1: 0
        x2: -0.7
        y2: 0.6
        x3: 0
        y3: 0
        x4: -0.7
        y4: -0.6
      .restoreCanvas()
      .restoreCanvas()
