utils = require './utils'

exports.Shot =
class Shot
  lifeLength: 200
  scalarSpeed: 5
  damage: 1

  constructor: (params) ->
    {@player, @emitter, @position, @limits, direction} = params
    @speed =
      x: Math.cos(utils.degToRad(direction)) * @scalarSpeed
      y: Math.sin(utils.degToRad(direction)) * @scalarSpeed
    @life = @lifeLength
    @emitter.on 'update', @update
    @emitter.on 'playerMoved', @checkHit

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
    @life <= 0

  hit: (player) ->
    @life = 0
    if player.hit(@damage)
      if @player isnt player
        @player.frag()
      else
        @player.autoFrag()

  checkHit: (player) =>
    if utils.distance(@position, player.position) < player.radius
      @hit(player)

  serialize: ->
    position: @position

  removeListeners: ->
    @emitter.removeListener 'update', @update
    @emitter.removeListener 'playerMoved', @checkHit
