{Server} = require 'ws'
{World} = require './world'

exports.run = ->
  screens = {}
  lastScreen = 0
  world = new World
    limits:
      width: 1200, height: 800

  wss = new Server(port: 3001)
  wss.on 'connection', (ws) ->

    if ws.protocol is 'screen'
      screenId = lastScreen
      lastScreen += 1
      console.log "  [*] Screen #{screenId} connected"

      update = ->
        data = world.serialize()
        ws.send JSON.stringify(data)

      screens[screenId] = setInterval(update, 32)

      ws.on 'close', ->
        clearInterval screens[screenId]
        delete screens[screenId]
        console.log "  [*] Screen #{screenId} disconnected"

    else if ws.protocol is 'controller'
      clientId = world.addPlayer()
      console.log "  [*] Controller #{clientId} connected"

      ws.on 'message', (message) ->
        data = JSON.parse(message)
        world.updatePlayersKeys(clientId, data)

      ws.on 'close', ->
        world.removePlayer(clientId)
        console.log "  [*] Client #{clientId} disconnected"
