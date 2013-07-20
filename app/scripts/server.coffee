{World} = require './world'

exports.Server =
class Server
  updateInterval: 32

  constructor: (port) ->
    @socketIo = require('socket.io').listen(port)
    @screens = {}
    @lastScreenId = 0
    @world = new World
      limits:
        width: 1200, height: 800
    @socketIo.set 'log level', 2
    @socketIo.on 'connection', @connection

  connection: (socket) =>
    switch socket.handshake.query.role
      when 'screen'
        @screen(socket)
      when 'controller'
       @controller(socket)

  screen: (socket) ->
    screenId = @lastScreenId
    @lastScreenId += 1
    console.log "[*] Screen #{screenId} connected. Using #{socket.transport}."

    update = =>
      socket.emit 'update', @world.serialize()

    @screens[screenId] = setInterval(update, @updateInterval)

    socket.on 'disconnect', =>
      clearInterval @screens[screenId]
      delete @screens[screenId]
      console.log "[*] Screen #{screenId} disconnected."

  controller: (socket) ->
    clientId = @world.addPlayer()
    console.log "[*] Controller #{clientId} connected. Using #{socket.transport}."
    socket.emit 'id', clientId

    socket.on 'keys', (data) =>
      @world.updatePlayersKeys(clientId, data)

    socket.on 'disconnect', =>
      @world.removePlayer(clientId)
      console.log "[*] Controller #{clientId} disconnected."
