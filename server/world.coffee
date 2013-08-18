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
    @projectiles = []
    dt = @updatePeriod / 1000
    setInterval ( => @update(dt) ), @updatePeriod

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

  update: (dt) ->
    for _, player of @players
      player.update(dt)
      @projectiles = @projectiles.concat(player.getProjectiles())

    for projectile in @projectiles
      projectile.update(dt)
      for _, player of @players
        break if player.checkHit(projectile)

    @projectiles = @projectiles.filter((projectile)->projectile.alive())

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
    projectiles = @projectiles.map (projectile) -> projectile.serialize()
    return {players: players, projectiles: projectiles}
