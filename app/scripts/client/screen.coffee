require ['drawer'], (Drawer) ->
  players = []
  shots = []
  drawer = null

  ws = new WebSocket 'ws://romankuznietsov.asuscomm.com:3001', 'screen'
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
