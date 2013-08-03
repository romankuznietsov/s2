{Shot} = require './shot'
utils = require './utils'

exports.Player =
class Player
  acceleration: 0.02
  topSpeed: 2
  turnSpeed: 1
  shotCooldown: 20
  maxHealth: 3
  radius: 10

  constructor: (params) ->
    {@limits, @emitShot, @color} = params
    @keys = {}
    @reset()
    @setRandomPosition()

  updateKeys: (keys) ->
    @keys = keys

  update: ->
    @accelerate() if @keys.up
    @brake() if @keys.down
    @turnLeft() if @keys.left
    @turnRight() if @keys.right
    @move()
    @cooldown -= 1 if @cooldown > 0
    @shoot() if @keys.fire and @cooldown is 0
    @respawn() if @dead()

  move: ->
    @position.x += Math.cos(@directionRad()) * @speed
    @position.y += Math.sin(@directionRad()) * @speed
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0

  respawn: ->
    @reset()
    @setRandomPosition()

  reset: ->
    @health = @maxHealth
    @cooldown = 0
    @speed = 0
    @direction = 0

  setRandomPosition: ->
    @position =
      x: @limits.width * Math.random()
      y: @limits.height * Math.random()

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
    @direction = 360 if @direction < 0

  turnRight: ->
    @direction += @turnSpeed
    @direction = 0 if @direction > 360

  serialize: ->
    position: @position
    direction: @direction
    health: @health / @maxHealth
    color: @color

  shoot: ->
    @cooldown = @shotCooldown
    @emitShot new Shot
      position:
        x: @position.x + Math.cos(@directionRad()) * @radius * 1.1
        y: @position.y + Math.sin(@directionRad()) * @radius * 1.1
      direction: @direction

  dead: ->
    @health <= 0

  hit: ->
    @health -= 1 if @health > 0
