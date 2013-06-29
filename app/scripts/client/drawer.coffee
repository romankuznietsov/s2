define ->
  class Drawer
    constructor: (canvas) ->
      @canvas = canvas
      @canvas.translateCanvas
        translateX: @canvas.width() / 2
        translateY: @canvas.height() / 2

    fill: (color = '#000') ->
      @canvas.drawArc
        x: 0, y: 0
        radius: 300
        fillStyle: color

    drawPlayer: (player) ->
      color = Math.round(player.health * 15).toString(16)
      @canvas
        .translateCanvas
          translateX: player.position.x
          translateY: player.position.y
        .drawLine
          rotate: player.direction
          strokeStyle: "#f#{color}#{color}"
          strokeWidth: 2
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
      @canvas.drawText
        strokeStyle: '#999'
        fillStyle: '#999'
        text: player.id
        x: player.position.x + 20
        y: player.position.y + 20
        fontFamily: 'sans-serif'
        fontSize: '10px'


    drawShot: (shot) ->
      @canvas.drawArc
        strokeStyle: '#ff0'
        strokeWidth: 1
        x: shot.position.x
        y: shot.position.y
        radius: 2
