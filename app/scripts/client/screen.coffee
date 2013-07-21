require ['drawer', '../socket.io-client/dist/socket.io.min'], (Drawer, SocketIo) ->
  players = []
  shots = []
  drawer = null
  canvas = null

  socket = SocketIo.connect window.location.origin, query: 'role=screen'

  socket.on 'update', (data) ->
    {players, shots} = data

  socket.on 'disconnect', ->
    console.log 'disconnected'

  update = ->
    drawer.clear()
    for player in players
      drawer.drawPlayer(player)
    for shot in shots
      drawer.drawShot(shot)

  fit = ->
    if window.innerWidth / window.innerHeight >= 1.5
      $(canvas).css('height', window.innerHeight * 0.95)
      $(canvas).css('width', window.innerHeight * 1.5 * 0.95)
    else
      $(canvas).css('width', window.innerWidth * 0.95)
      $(canvas).css('height', window.innerWidth / 1.5 * 0.95)

  $ ->
    canvas = $('#canvas')
    drawer = new Drawer(canvas)
    setInterval(update, 10)
    fit()

  $(window).resize fit
