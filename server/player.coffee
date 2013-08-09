{Shot} = require './shot'
utils = require './utils'

exports.Player =
class Player
  score: 0
  keys: {}

  constructor: (params) ->
    {ship, @limits, @color} = params
    for key, value of ship
      @[key] = value
    @respawn()

  setKeys: (keys) ->
    @keys = keys

  serialize: ->
    radius: @radius
    position: @position
    direction: @direction
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
    @cooldown -= 1 if @cooldown > 0

  move: ->
    @position.x += Math.cos(@movementDirectionRad()) * @speed
    @position.y += Math.sin(@movementDirectionRad()) * @speed
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0

  updateMovementDirection: ->
    diff = @direction - @movementDirection
    diff -= 360 if diff > 180
    diff += 360 if diff < -180
    @movementDirection += diff / @inertia
    @movementDirection += 360 if @movementDirection < 0
    @movementDirection -= 360 if @movementDirection >= 360

  respawn: ->
    @health = @maxHealth
    @cooldown = 0
    @speed = 0
    @direction = 0
    @movementDirection = 0
    @position =
      x: @limits.width * Math.random()
      y: @limits.height * Math.random()

  movementDirectionRad: ->
    utils.degToRad(@movementDirection)

  directionRad: ->
    utils.degToRad(@direction)

  accelerate: ->
    @speed += @acceleration
    @speed = @topSpeed if @speed > @topSpeed

  brake: ->
    @speed -= @acceleration
    @speed = 0 if @speed < 0

  turnLeft: ->
    @direction -= @turnSpeed
    @direction += 360 if @direction < 0

  turnRight: ->
    @direction += @turnSpeed
    @direction -= 360 if @direction >= 360

  getShots: ->
    if @cooldown is 0 && @keys.fire
      @cooldown = @shotCooldown
      shot = new Shot
        position:
          x: @position.x + Math.cos(@directionRad()) * @radius
          y: @position.y + Math.sin(@directionRad()) * @radius
        direction: @direction
        limits: @limits
        shooter: @
      [shot]
    else
      []

  checkHit: (shot) ->
    if utils.distance(shot.position, @position) < @radius
      @health -= shot.damage
      shot.destroy()
      if @health <= 0
        @respawn()
        if shot.shooter isnt @
          shot.shooter.frag()
        else
          @autoFrag()
      return true
    else
      return false

  frag: ->
    @score += 1

  autoFrag: ->
    @score -= 1
