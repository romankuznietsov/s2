require ['drawer', 'config'], (Drawer, config) ->
  ws = new WebSocket config.wsServer, 'screen'

  players = []
  shots = []
  drawer = null

  ws.onmessage = (message) ->
    data = JSON.parse message.data
    {players, shots} = data
  ws.onclose = ->
    console.log 'disconnected'

  update = ->
    drawer.fill()
    for player in players
      drawer.drawPlayer(player)
    for shot in shots
      drawer.drawShot(shot)

  $ ->
    drawer = new Drawer($ 'canvas')
    setInterval(update, 10)
