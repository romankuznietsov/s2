{Player} = require './player'
utils = require './utils'

exports.World =
class World
  constructor: (params) ->
    {@radius} = params
    @players = {}
    @shots = []
    setInterval(@update, 10)

  addPlayer: ->
    player = new Player
      position: @randomPosition()
      direction: 0
      emitShot: @emitShot
    @players[player.id] = player
    return player.id

  removePlayer: (id) ->
    delete @players[id]

  updatePlayersKeys: (id, keys) ->
    @players[id].updateKeys keys

  update: =>
    for id, player of @players
      player.update()
      player.respawn(@randomPosition()) if player.dead()
      @limitPosition(player)
    for shot in @shots
      shot.update()
      @limitPosition(shot)
    @shots = @shots.filter (shot) -> shot.dead() isnt true
    @checkHits()

  emitShot: (shot) =>
    @shots.push shot

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

  limitPosition: (object) ->
    if utils.distance(object.position, {x: 0, y: 0}) >= @radius
      object.position.x *= -1
      object.position.y *= -1

  randomPosition: ->
    x: Math.random() * @radius / 2 - @radius / 4
    y: Math.random() * @radius / 2 - @radius / 4
