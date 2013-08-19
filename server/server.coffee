{World} = require './world'

exports.Server =
class Server
  updateInterval: 32

  constructor: (port) ->
    @socketIo = require('socket.io').listen(port)
    @screens = {}
    @controllers = {}
    @lastScreenId = 0
    @lastControllerId = 0
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

    socket.emit 'limits', @world.limits

    update = =>
      socket.emit 'update', @world.serialize()

    @screens[screenId] = setInterval(update, @updateInterval)

    socket.on 'disconnect', =>
      clearInterval @screens[screenId]
      delete @screens[screenId]

  controller: (socket) ->
    {status, id} = @world.addPlayer()
    controllerId = @lastControllerId
    @lastControllerId += 1

    update = =>
      socket.emit 'update', @world.stats(id)

    if status is 'connected'
      socket.on 'selectShip', (ship) =>
        color = @world.join(id, ship)
        socket.emit 'join', color
        @controllers[controllerId] = setInterval(update, @updateInterval)

      socket.on 'keys', (keys) =>
        @world.setPlayersKeys(id, keys)

      socket.on 'disconnect', =>
        @world.removePlayer(id)
        @controllers[controllerId] &&
          clearInterval(@controllers[controllerId])
        delete @controllers[controllerId]

      socket.emit 'ships', @world.ships()

    else
      socket.disconnect()
