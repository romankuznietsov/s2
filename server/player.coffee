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

  update: =>
    @accelerate() if @keys.up
    @brake() if @keys.down
    @turnLeft() if @keys.left
    @turnRight() if @keys.right
    @updateMovementDirection()
    @move()
    @weapon.update()

  move: ->
    @position.x += Math.cos(@movementDirection) * @speed
    @position.y += Math.sin(@movementDirection) * @speed
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0

  updateMovementDirection: ->
    diff = @direction - @movementDirection
    diff -= twoPi if diff > pi
    diff += twoPi if diff < -pi
    @movementDirection += diff / @inertia
    @movementDirection += twoPi if @movementDirection < 0
    @movementDirection -= twoPi if @movementDirection >= twoPi

  respawn: ->
    @health = @maxHealth
    @speed = 0
    @direction = 0
    @movementDirection = 0
    @position =
      x: @limits.width * Math.random()
      y: @limits.height * Math.random()

  accelerate: ->
    @speed += @acceleration
    @speed = @topSpeed if @speed > @topSpeed

  brake: ->
    @speed -= @acceleration
    @speed = 0 if @speed < 0

  turnLeft: ->
    @direction -= @turnSpeed
    @direction += twoPi if @direction < 0

  turnRight: ->
    @direction += @turnSpeed
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
      @health -= projectile.damage
      projectile.destroy()
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
