require ['drawer', '../socket.io-client/dist/socket.io.min'], (Drawer, SocketIo) ->
  class Screen
    redrawPeriod: 32
    statusBarHeight: 30

    constructor: ->
      @players = []
      @shots = []
      @canvas = $('#canvas')
      @drawer = new Drawer(@canvas)
      @connect()
      setInterval(@redraw, @redrawPeriod)
      $(window).resize @fitCanvas

    connect: ->
      @socket = SocketIo.connect window.location.origin,
        query: 'role=screen'
      @socket.on 'limits', @setLimits
      @socket.on 'update', @update
      @socket.on 'disconnected', @disconnect

    setLimits: (data) =>
      {@width, @height} = data
      @drawer.setStatusBarParams
        x: 0, y: @height
        width: @width
        height: @statusBarHeight

      @height += @statusBarHeight
      @canvas.attr 'width', @width
      @canvas.attr 'height', @height
      @fitCanvas()

    update: (data) =>
      {@players, @shots} = data

    disconnect: ->
      console.log 'disconnected'

    redraw: =>
      @drawer.clear()
      for player in @players
        @drawer.drawPlayer(player) if player
      for shot in @shots
        @drawer.drawShot(shot)
      @drawer.statusBar(@players)

    fitCanvas: =>
      ratio = @width / @height
      if window.innerWidth / window.innerHeight >= ratio
        @canvas.height window.innerHeight * 0.95
        @canvas.width window.innerHeight * ratio * 0.95
      else
        @canvas.width window.innerWidth * 0.95
        @canvas.height window.innerWidth / ratio * 0.95

  $ ->
    new Screen
