{EventEmitter} = require 'events'
{Player} = require './player'
ships = require './ships'

exports.World =
class World
  colors: [
    '#1ABC9C', '#2ECC71', '#3468DB', '#9B59B6',
    '#F1C40F', '#E67E22', '#E74C3C', '#ECF0F1'
  ]
  updatePeriod: 10

  constructor: (params) ->
    {@limits} = params
    @emitter = new EventEmitter
    @emitter.setMaxListeners(1000)
    @players = {}
    @lastPlayerId = 0
    @shots = []
    @emitter.on 'shots', @addShots
    setInterval(@update, @updatePeriod)

  addPlayer: ->
    return {status: 'rejected'} if @playerLimitReached()
    player = new Player
      limits: @limits
      color: @colors.pop()
      emitter: @emitter
    @lastPlayerId += 1
    @players[@lastPlayerId] = player
    return status: 'connected', id: @lastPlayerId, color: player.color

  removePlayer: (id) ->
    @colors.push @players[id].disconnect()
    delete @players[id]

  setPlayersKeys: (id, keys) ->
    @players[id].setKeys keys

  playerLimitReached: ->
    @colors.length == 0

  update: =>
    @emitter.emit 'update'
    @shots = @shots.filter((shot)->shot.alive())

  addShots: (shots) =>
    @shots = @shots.concat shots

  ships: ->
    ships

  join: (id, ship) ->
    @players[id].join(ships[ship])

  serialize: () ->
    players = []
    for id, player of @players
      players.push player.serialize() if player.joined
    shots = @shots.map (shot) -> shot.serialize()
    return {players: players, shots: shots}
