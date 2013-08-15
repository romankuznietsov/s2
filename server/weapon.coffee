{Projectile} = require './projectile'

exports.Weapon =
class Weapon
  constructor: (params) ->
    {@cooldown, @projectile, @spread, @projectilesPerShot} = params
    @cooldownLeft = 0

  update: ->
    @cooldownLeft -= 1
    @cooldownLeft = 0 if @cooldownLeft < 0

  shoot: (direction, shooterParams) ->
    if @cooldownLeft is 0
      @cooldownLeft = @cooldown
      [1..@projectilesPerShot].map =>
        projectileDirection = direction + 2 * Math.random() * @spread - @spread
        new Projectile(@projectile, shooterParams, projectileDirection)
    else
      []
