require ['drawer', 'config'], (Drawer, config) ->
  ws = new WebSocket config.wsServer, 'screen'

  players = []
  shots = []
  drawer = null
  canvas = null

  ws.onmessage = (message) ->
    data = JSON.parse message.data
    {players, shots} = data
  ws.onclose = ->
    console.log 'disconnected'

  update = ->
    drawer.clear()
    for player in players
      drawer.drawPlayer(player)
    for shot in shots
      drawer.drawShot(shot)

  fit = ->
    console.log 'fit'
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
