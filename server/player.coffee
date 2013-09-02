{Weapon} = require './weapon'
{Projectile} = require './projectile'

distance = (p1, p2) ->
  Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2))
pi = Math.PI
twoPi = pi * 2

exports.Player =
class Player
  score: 0
  keys: {}
  invincibleTime: 3
  invincibleTimeLeft: 0

  constructor: (params) ->
    {ship, @limits, @color} = params
    for key, value of ship
      @[key] = value unless key == 'weapon'
    @weapon = new Weapon(params.ship.weapon)
    @respawn()

  setKeys: (keys) ->
    @keys = keys

  serialize: ->
    radius: @radius
    position: @position
    direction: @direction / pi * 180
    health: @health / @maxHealth
    color: @color
    score: @score
    invincible: @invincible()
    type: @type

  stats: ->
    health: @health / @maxHealth * 100
    score: @score

  update: (dt) =>
    @accelerate(dt) if @keys.up
    @brake(dt) if @keys.down
    @turnLeft(dt) if @keys.left
    @turnRight(dt) if @keys.right
    @updateMovementDirection(dt)
    @move(dt)
    @weapon.update(dt)
    @invincibleTimeLeft -= dt if @invincible()

  move: (dt) ->
    @position.x += Math.cos(@movementDirection) * @speed * dt
    @position.y += Math.sin(@movementDirection) * @speed * dt
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0

  updateMovementDirection: (dt) ->
    diff = @direction - @movementDirection
    diff -= twoPi if diff > pi
    diff += twoPi if diff < -pi
    @movementDirection += diff * dt / @inertia
    @movementDirection += twoPi if @movementDirection < 0
    @movementDirection -= twoPi if @movementDirection >= twoPi

  respawn: ->
    @invincibleTimeLeft = @invincibleTime
    @health = @maxHealth
    @speed = 0
    @direction = 0
    @movementDirection = 0
    @position =
      x: @limits.width * Math.random()
      y: @limits.height * Math.random()

  accelerate: (dt) ->
    @speed += @acceleration * dt
    @speed = @topSpeed if @speed > @topSpeed

  brake: (dt) ->
    @speed -= @acceleration * dt
    @speed = 0 if @speed < 0

  turnLeft: (dt) ->
    @direction -= @turnSpeed * dt
    @direction += twoPi if @direction < 0

  turnRight: (dt) ->
    @direction += @turnSpeed * dt
    @direction -= twoPi if @direction >= twoPi

  getProjectiles: ->
    if @keys.fire
      position =
        x: @position.x + Math.cos(@direction) * @radius
        y: @position.y + Math.sin(@direction) * @radius
      @weapon.shoot(@direction, shooter: @, limits: @limits, position: position)
    else
      []

  checkHit: (projectile) ->
    if distance(projectile.position, @position) < @radius
      projectile.destroy()
      unless @invincible()
        @health -= projectile.damage
        if @health <= 0
          @respawn()
          if projectile.shooter isnt @
            projectile.shooter.frag()
          else
            @autoFrag()
      return true
    else
      return false

  frag: ->
    @score += 1

  autoFrag: ->
    @score -= 1

  invincible: ->
    @invincibleTimeLeft > 0
