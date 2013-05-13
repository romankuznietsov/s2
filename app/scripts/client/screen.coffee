require ['drawer'], (Drawer) ->
  wsPort = 3001
  wsServerPath = "ws://#{window.location.hostname}:#{wsPort}"
  ws = new WebSocket wsServerPath, 'screen'

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
