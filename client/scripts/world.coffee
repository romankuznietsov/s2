define ['player', 'projectile'], (Player, Projectile) ->
  class World
    predictionPeriod: 10
    players: []
    projectiles: []

    constructor: ->
      dt = @predictionPeriod / 1000
      setInterval ( => @predict(dt) ), @predictionPeriod

    predict: (dt) ->
      @players.forEach (player) ->
        player.predict(dt)
      @projectiles.forEach (projectile) ->
        projectile.predict(dt)

    update: (data) ->
      @players = data.players.map (player) ->
        new Player(player)
      @projectiles = data.projectiles.map (projectile) ->
        new Projectile(projectile)
