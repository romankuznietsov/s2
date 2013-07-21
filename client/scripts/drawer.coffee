define ->
  class Drawer
    constructor: (canvas) ->
      @canvas = canvas

    clear: ->
      @canvas.clearCanvas fillStyle: 'black'

    drawPlayer: (player) ->
      color = Math.round(player.health * 15).toString(16)
      @canvas
        .translateCanvas
          translateX: player.position.x
          translateY: player.position.y
        .drawLine
          rotate: player.direction
          fillStyle: player.color
          closed: true
          rounded: true
          x1: 15
          y1: 0
          x2: -8
          y2: 8
          x3: 0
          y3: 0
          x4: -8
          y4: -8
        .restoreCanvas()

    drawShot: (shot) ->
      @canvas.drawArc
        fillStyle: '#ff0'
        x: shot.position.x
        y: shot.position.y
        radius: 2
