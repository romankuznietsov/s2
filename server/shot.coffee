utils = require './utils'

exports.Shot =
class Shot
  lifeLength: 200
  scalarSpeed: 3

  constructor: (params) ->
    {@emitter, @position, @limits, direction} = params
    @speed =
      x: Math.cos(utils.degToRad(direction)) * @scalarSpeed
      y: Math.sin(utils.degToRad(direction)) * @scalarSpeed
    @life = @lifeLength
    @hit = false
    @emitter.on 'update', @update

  update: =>
    @life -= 1
    @move()

  move: ->
    @position.x += @speed.x
    @position.y += @speed.y
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0

  dead: ->
    @life <= 0 || @hit

  hitShip: ->
    @hit = true

  serialize: ->
    position: @position
