{Shot} = require './shot'
utils = require './utils'

exports.Player =
class Player
  constructor: (params) ->
    {@limits, @color, @emitter} = params

  setKeys: (keys) ->
    @keys = keys

  join: (ship) ->
    for key, value of ship
      @[key] = value
    @emitter.on 'update', @update
    @respawn()
    @joined = true

  disconnect: ->
    @removeListeners()
    @color

  hit: (player, damage) ->
    @health -= damage
    if @health <= 0
      @respawn()
      if player is @
        @score -= 1
      else
        player.score += 1

  collidesWith: (point) ->
    utils.distance(point, @position) < @radius

  serialize: ->
    radius: @radius
    position: @position
    direction: @direction
    health: @health / @maxHealth
    color: @color
    score: @score

  joined: false
  score: 0

  # private

  keys: {}

  acceleration: 0.02
  topSpeed: 2
  turnSpeed: 1
  inertia: 35
  shotCooldown: 20
  maxHealth: 3
  radius: 10

  update: =>
    @accelerate() if @keys.up
    @brake() if @keys.down
    @turnLeft() if @keys.left
    @turnRight() if @keys.right
    @updateMovementDirection()
    @move()
    @cooldown -= 1 if @cooldown > 0
    @shoot() if @keys.fire and @cooldown is 0
    @emitter.emit 'playerMoved', @

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

  shoot: ->
    @cooldown = @shotCooldown
    shot = new Shot
      emitter: @emitter
      position:
        x: @position.x + Math.cos(@directionRad()) * @radius
        y: @position.y + Math.sin(@directionRad()) * @radius
      direction: @direction
      limits: @limits
      shooter: @
    @emitter.emit 'shots', [shot]

  removeListeners: ->
    @emitter.removeListener 'update', @update
