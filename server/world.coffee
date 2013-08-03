{Player} = require './player'
utils = require './utils'
{EventEmitter} = require 'events'

exports.World =
class World
  colors: [
    '#1ABC9C', '#2ECC71', '#3468DB', '#9B59B6',
    '#F1C40F', '#E67E22', '#E74C3C', '#ECF0F1'
  ]

  constructor: (params) ->
    {@limits} = params
    @emitter = new EventEmitter
    @players = {}
    @lastPlayerId = 0
    @shots = []
    @emitter.on 'shots', @addShots
    setInterval(@update, 10)

  join: ->
    return {status: 'rejected'} if @playerLimitReached()
    player = new Player
      limits: @limits
      color: @colors.pop()
      emitter: @emitter
    @lastPlayerId += 1
    @players[@lastPlayerId] = player
    return status: 'connected', id: @lastPlayerId, color: player.color

  removePlayer: (id) ->
    @colors.push @players[id].color
    delete @players[id]

  updatePlayersKeys: (id, keys) ->
    @players[id].updateKeys keys

  playerLimitReached: ->
    @colors.length == 0

  update: =>
    @emitter.emit 'update'
    @shots = @shots.filter (shot) -> shot.dead() isnt true
    @checkHits()

  addShots: (shots) =>
    @shots = @shots.concat shots

  checkHits: ->
    for id, player of @players
      for shot in @shots
        if utils.distance(player.position, shot.position) < player.radius
          shot.hitShip()
          player.hit()

  serialize: () ->
    players = []
    for id, player of @players
      players.push player.serialize()
    shots = @shots.map (shot) -> shot.serialize()
    return {players: players, shots: shots}
