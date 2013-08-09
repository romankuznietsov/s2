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
    @players = {}
    @pendingPlayers = {}
    @lastPlayerId = 0
    @shots = []
    setInterval(@update, @updatePeriod)

  addPlayer: ->
    return {status: 'rejected'} if @playerLimitReached()
    @lastPlayerId += 1
    @pendingPlayers[@lastPlayerId] = @colors.pop()
    return status: 'connected', id: @lastPlayerId

  removePlayer: (id) ->
    if @pendingPlayers[id]
      @colors.push @pendingPlayers[id]
      delete @pendingPlayers[id]
    else
      @colors.push @players[id].color
      delete @players[id]

  setPlayersKeys: (id, keys) ->
    @players[id].setKeys keys

  playerLimitReached: ->
    @colors.length == 0

  update: =>
    for _, player of @players
      player.update()
      @shots = @shots.concat(player.getShots())

    for shot in @shots
      shot.update()
      for _, player of @players
        break if player.checkHit(shot)

    @shots = @shots.filter((shot)->shot.alive())

  ships: ->
    ships

  join: (id, shipName) ->
    color = @pendingPlayers[id]
    @players[id] = new Player
      color: color
      limits: @limits
      ship: ships[shipName]
    delete @pendingPlayers[id]
    return color

  serialize: () ->
    players = []
    for id, player of @players
      players.push player.serialize()
    shots = @shots.map (shot) -> shot.serialize()
    return {players: players, shots: shots}
