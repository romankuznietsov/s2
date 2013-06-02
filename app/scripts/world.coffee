{Player} = require './player'
utils = require './utils'

exports.World =
class World
  constructor: (params) ->
    {@limits} = params
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
      shot.update(@limits)
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
    object.position.x = 0 if object.position.x > @limits.width
    object.position.x = @limits.width if object.position.x < 0
    object.position.y = 0 if object.position.y > @limits.height
    object.position.y = @limits.height if object.position.y < 0

  randomPosition: ->
    x: Math.random() * @limits.width
    y: Math.random() * @limits.height
