utils = require './utils'

exports.Shot =
class Shot
  lifeLength: 200
  scalarSpeed: 3

  constructor: (params) ->
    {@position, direction} = params
    @speed =
      x: Math.cos(utils.degToRad(direction)) * @scalarSpeed
      y: Math.sin(utils.degToRad(direction)) * @scalarSpeed
    @life = @lifeLength
    @hit = false

  update: ->
    @life -= 1
    @position.x += @speed.x
    @position.y += @speed.y

  dead: ->
    @life <= 0 || @hit

  hitShip: ->
    @hit = true

  serialize: ->
    position: @position
