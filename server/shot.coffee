utils = require './utils'

exports.Shot =
class Shot
  lifeLength: 200
  scalarSpeed: 5
  damage: 1

  constructor: (params) ->
    {@shooter, @position, @limits, direction} = params
    @speed =
      x: Math.cos(utils.degToRad(direction)) * @scalarSpeed
      y: Math.sin(utils.degToRad(direction)) * @scalarSpeed
    @life = @lifeLength

  serialize: ->
    position: @position

  alive: ->
    @life > 0

  update: =>
    @move()

  destroy: ->
    @life = 0

  move: ->
    @position.x += @speed.x
    @position.y += @speed.y
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0
