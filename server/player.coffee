{Shot} = require './shot'
utils = require './utils'

exports.Player =
class Player
  joined: false

  acceleration: 0.02
  topSpeed: 2
  turnSpeed: 1
  inertia: 35
  shotCooldown: 20
  maxHealth: 3
  radius: 10

  constructor: (params) ->
    {@limits, @color, @emitter} = params
    @keys = {}

  updateKeys: (keys) ->
    @keys = keys

  update: =>
    @accelerate() if @keys.up
    @brake() if @keys.down
    @turnLeft() if @keys.left
    @turnRight() if @keys.right
    @updateRealDirection()
    @move()
    @cooldown -= 1 if @cooldown > 0
    @shoot() if @keys.fire and @cooldown is 0
    @respawn() if @dead()

  move: ->
    @position.x += Math.cos(@realDirectionRad()) * @speed
    @position.y += Math.sin(@realDirectionRad()) * @speed
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0

  updateRealDirection: ->
    diff = @direction - @realDirection
    diff -= 360 if diff > 180
    diff += 360 if diff < -180
    @realDirection += diff / @inertia
    @realDirection += 360 if @realDirection < 0
    @realDirection -= 360 if @realDirection >= 360

  respawn: ->
    @reset()
    @setRandomPosition()

  reset: ->
    @health = @maxHealth
    @cooldown = 0
    @speed = 0
    @direction = 0
    @realDirection = 0

  setRandomPosition: ->
    @position =
      x: @limits.width * Math.random()
      y: @limits.height * Math.random()

  realDirectionRad: ->
    utils.degToRad(@realDirection)

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

  serialize: ->
    @joined and {
      radius: @radius
      position: @position
      direction: @direction
      health: @health / @maxHealth
      color: @color
    }

  shoot: ->
    @cooldown = @shotCooldown
    shot = new Shot
      emitter: @emitter
      position:
        x: @position.x + Math.cos(@directionRad()) * @radius * 1.1
        y: @position.y + Math.sin(@directionRad()) * @radius * 1.1
      direction: @direction
      limits: @limits
    @emitter.emit 'shots', [shot]

  dead: ->
    @health <= 0

  hit: ->
    @health -= 1 if @health > 0

  checkHit: (shot) =>
    if utils.distance(@position, shot.position) < @radius
      @hit()
      shot.hitShip()

  removeListeners: ->
    @emitter.removeListener 'update', @update
    @emitter.removeListener 'shotMoved', @checkHit

  setShip: (ship) ->
    for key, value of ship
      @[key] = value

  join: ->
    @emitter.on 'update', @update
    @emitter.on 'shotMoved', @checkHit
    @reset()
    @setRandomPosition()
    @joined = true
