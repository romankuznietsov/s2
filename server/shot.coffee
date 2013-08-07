utils = require './utils'

exports.Shot =
class Shot
  constructor: (params) ->
    {@shooter, @emitter, @position, @limits, direction} = params
    @speed =
      x: Math.cos(utils.degToRad(direction)) * @scalarSpeed
      y: Math.sin(utils.degToRad(direction)) * @scalarSpeed
    @move()
    @life = @lifeLength
    @emitter.on 'update', @update
    @emitter.on 'playerMoved', @checkCollision

  serialize: ->
    position: @position

  alive: ->
    @life > 0

  # private

  lifeLength: 200
  scalarSpeed: 5
  damage: 1

  update: =>
    @life -= 1
    if @life <= 0
      @removeListeners()
    else
      @move()

  move: ->
    @position.x += @speed.x
    @position.y += @speed.y
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0

  checkCollision: (player) =>
    if player.collidesWith(@position)
      player.hit(@shooter, @damage)
      @die()

  die: ->
    @life = 0
    @removeListeners()

  removeListeners: ->
    @emitter.removeListener 'update', @update
    @emitter.removeListener 'playerMoved', @checkCollision
