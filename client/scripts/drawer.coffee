define ->
  class Drawer
    constructor: (canvas) ->
      @canvas = canvas

    clear: ->
      @canvas.clearCanvas fillStyle: 'black'

    drawPlayer: (player) ->
      @canvas
        .translateCanvas
          translateX: player.position.x
          translateY: player.position.y
        .drawArc
          strokeStyle: "rgba(0, 160, 255, #{player.health})"
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

    drawShot: (shot) ->
      @canvas.drawArc
        fillStyle: '#ff0'
        x: shot.position.x
        y: shot.position.y
        radius: 2

    setStatusBarParams: (params) ->
      @statusBarParams = params
      @statusBarParams.iconRadius = params.height / 3
      @statusBarParams.fontSize = params.height / 1.5
      @statusBarParams.offset = @statusBarParams.fontSize * 4

    statusBar: (players) ->
      return unless @statusBarParams
      @canvas.drawRect
        x: @statusBarParams.x, y: @statusBarParams.y
        fromCenter: false
        height: @statusBarParams.height
        width: @statusBarParams.width
        fillStyle: 'black'
        strokeStyle: 'rgb(0, 160, 255)'

      @canvas.translateCanvas
        translateX: @statusBarParams.fontSize, translateY: @statusBarParams.y + @statusBarParams.height / 2

      for i in [ 0...players.length ]
        @canvas.drawArc
          x: @statusBarParams.offset * i
          y: 0
          radius: @statusBarParams.iconRadius
          fillStyle: players[i].color
        @canvas.drawText
          strokeStyle: 'white'
          fillStyle: 'white'
          x: @statusBarParams.height + @statusBarParams.offset * i
          y: 0
          fontSize: @statusBarParams.fontSize
          fontFamily: 'sans-serif'
          text: players[i].score

      @canvas.restoreCanvas()
