WebSocketServer = require('ws').Server
{World} = require './world'

exports.Server =
class Server
  updateInterval: 32

  constructor: (port) ->
    @port = port
    @screens = {}
    @lastScreenId = 0
    @world = new World
      limits:
        width: 1200, height: 800
    @webSocketServer = new WebSocketServer(port: @port)
    console.log "Started websocket server on port #{@port}."
    @webSocketServer.on 'connection', @connection

  connection: (ws) =>
    switch ws.protocol
      when 'screen'
        @screen(ws)
      when 'controller'
       @controller(ws)

  screen: (ws) ->
    screenId = @lastScreenId
    @lastScreenId += 1
    console.log "[*] Screen #{screenId} connected."

    update = =>
      data = @world.serialize()
      ws.send JSON.stringify(data)

    @screens[screenId] = setInterval(update, @updateInterval)

    ws.on 'close', =>
      clearInterval @screens[screenId]
      delete @screens[screenId]
      console.log "[*] Screen #{screenId} disconnected."

  controller: (ws) ->
    clientId = @world.addPlayer()
    console.log "[*] Controller #{clientId} connected."
    ws.send clientId.toString()

    ws.on 'message', (message) =>
      data = JSON.parse(message)
      @world.updatePlayersKeys(clientId, data)

    ws.on 'close', =>
      @world.removePlayer(clientId)
      console.log "[*] Controller #{clientId} disconnected."
