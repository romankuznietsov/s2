define ->
  class Screen
    canvasSelector: '#canvas'
    redrawPeriod: 32
    statusBar:
      height: 30
      iconRadius: 10
      fontSize: 20
      itemWidth: 80
      padding: 30
      y: 0
    players: []
    projectiles: []

    constructor: ->
      @canvas = $(@canvasSelector)
      $(window).resize @fitCanvas
      setInterval(@redraw, @redrawPeriod)

    update: (data) =>
      {@players, @projectiles} = data

    redraw: =>
      @canvas.clearCanvas fillStyle: 'black'
      for player in @players
        @drawPlayer(player)
      for projectile in @projectiles
        @drawProjectile(projectile)
      @drawStatusBar()

    setLimits: (limits) =>
      {@width, @height} = limits

      @statusBar.y = @height
      @height += @statusBar.height

      @canvas.attr 'width', @width
      @canvas.attr 'height', @height
      @fitCanvas()

    drawPlayer: (player) ->
      @canvas
        .translateCanvas
          translateX: player.position.x
          translateY: player.position.y
        .drawArc
          strokeStyle: "rgba(0, 160, 255, #{player.health.toFixed(2)})"
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

    drawProjectile: (projectile) ->
      switch projectile.type
        when 'blast' then @drawBlast(projectile)
        when 'bullet' then @drawBullet(projectile)

    drawBullet: (projectile) ->
      @canvas.drawLine
        strokeStyle: '#ff0'
        strokeWidth: 1
        x1: projectile.position.x
        y1: projectile.position.y
        x2: projectile.position.x + projectile.speedVector.x / 100
        y2: projectile.position.y + projectile.speedVector.y / 100

    drawBlast: (projectile) ->
      @canvas.drawArc
        fillStyle: '#ff0'
        x: projectile.position.x
        y: projectile.position.y
        radius: 2

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
          fillStyle: @players[i].color
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
