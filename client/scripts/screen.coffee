define ['projectile_view', 'player_view'], (projectileView, playerView) ->
  class Screen
    players: []
    projectiles: []
    canvasSelector: '#canvas'
    redrawPeriod: 32
    statusBar:
      height: 30
      iconRadius: 10
      fontSize: 20
      itemWidth: 80
      padding: 30
      y: 0

    constructor: ->
      @canvas = $(@canvasSelector)
      $(window).resize @fitCanvas
      setInterval(@redraw, @redrawPeriod)

    update: (data) =>
      {@players, @projectiles} = data

    redraw: =>
      @canvas.clearCanvas fillStyle: 'black'
      for player in @players
        playerView(@canvas, player)
      for projectile in @projectiles
        projectileView(@canvas, projectile)
      @drawStatusBar()

    setLimits: (limits) =>
      {@width, @height} = limits

      @statusBar.y = @height
      @height += @statusBar.height

      @canvas.attr 'width', @width
      @canvas.attr 'height', @height
      @fitCanvas()

    drawStatusBar: ->
      @canvas.drawRect
        x: 0, y: @statusBar.y
        fromCenter: false
        height: @statusBar.height
        width: @width
        fillStyle: 'black'
        strokeStyle: 'rgb(0, 160, 255)'

      @canvas.translateCanvas
        translateX: @statusBar.padding
        translateY: @statusBar.y + @statusBar.height / 2

      for i in [ 0...@players.length ]
        @canvas.drawArc
          x: @statusBar.itemWidth * i
          y: 0
          radius: @statusBar.iconRadius
          fillStyle: @players[i].color.value
        @canvas.drawText
          strokeStyle: 'white'
          fillStyle: 'white'
          x: @statusBar.padding + @statusBar.itemWidth * i
          y: 0
          fontSize: @statusBar.fontSize
          fontFamily: 'sans-serif'
          text: @players[i].score

      @canvas.restoreCanvas()

    fitCanvas: =>
      ratio = @width / @height
      if window.innerWidth / window.innerHeight >= ratio
        @canvas.height window.innerHeight * 0.95
        @canvas.width window.innerHeight * ratio * 0.95
      else
        @canvas.width window.innerWidth * 0.95
        @canvas.height window.innerWidth / ratio * 0.95
