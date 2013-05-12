{Shot} = require './shot'
utils = require './utils'

exports.Player =
class Player
  acceleration: 0.01
  topSpeed: 2
  turnSpeed: 2
  shotCooldown: 20
  maxHealth: 3
  radius: 10

  constructor: (params) ->
    @id = Player.lastId
    Player.lastId += 1
    {@position, @direction} = params
    @speed = 0
    @cooldown = 0
    @keys = {}
    @health = @maxHealth

  updateKeys: (keys) ->
    @keys = keys

  update: ->
    @accelerate() if @keys.up
    @brake() if @keys.down
    @turnLeft() if @keys.left
    @turnRight() if @keys.right
    @position.x += Math.cos(@directionRad()) * @speed
    @position.y += Math.sin(@directionRad()) * @speed
    @cooldown -= 1 if @cooldown > 0

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
    id: @id
    position: @position
    direction: @direction
    health: @health / @maxHealth

  getShots: ->
    shots = []
    if @keys.fire and @cooldown is 0
      @cooldown = @shotCooldown
      shots.push @createShot()
    return shots

  createShot: ->
    new Shot
      position:
        x: @position.x + Math.cos(@directionRad()) * @radius * 1.1
        y: @position.y + Math.sin(@directionRad()) * @radius * 1.1
      direction: @direction

  dead: ->
    @health <= 0

  respawn: (position) ->
    @health = @maxHealth
    @cooldown = 0
    @speed = 0
    @direction = 0
    @position = position

  hit: ->
    @health -= 1 if @health > 0

Player.lastId = 0
