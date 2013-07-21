{Player} = require './player'
utils = require './utils'

exports.World =
class World
  colors: [
    '#1ABC9C', '#2ECC71', '#3468DB', '#9B59B6',
    '#F1C40F', '#E67E22', '#E74C3C', '#ECF0F1'
  ]

  constructor: (params) ->
    {@limits} = params
    @players = {}
    @lastPlayerId = 0
    @shots = []
    setInterval(@update, 10)

  join: ->
    return {status: 'rejected'} if @playerLimitReached()
    player = new Player
      position: @randomPosition()
      direction: 0
      emitShot: @emitShot
      color: @colors.pop()
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
    object.position.x -= @limits.width if object.position.x > @limits.width
    object.position.x += @limits.width if object.position.x < 0
    object.position.y -= @limits.height if object.position.y > @limits.height
    object.position.y += @limits.height if object.position.y < 0

  randomPosition: ->
    x: Math.random() * @limits.width
    y: Math.random() * @limits.height
