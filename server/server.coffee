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
    {status, id, color} = @world.join()
    if status is 'connected'
      console.log "[*] Controller #{id} connected. Using #{socket.transport}."
      socket.emit 'connected', color
      socket.on 'keys', (data) =>
        @world.updatePlayersKeys(id, data)
      socket.on 'disconnect', =>
        @world.removePlayer(id)
        console.log "[*] Controller #{id} disconnected."
    else
      console.log '[*] Connection rejected. Room if full.'
      socket.disconnect('Room is full')
      return
