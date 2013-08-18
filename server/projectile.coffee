exports.Projectile =
class Projectile
  constructor: (params, shooterParams, direction) ->
    {speed, range, @damage, @type} = params
    @life = range / speed
    {@shooter, @position, @limits} = shooterParams
    @speedVector =
      x: Math.cos(direction) * speed
      y: Math.sin(direction) * speed

  serialize: ->
    position: @position
    type: @type
    speedVector: @speedVector

  alive: ->
    @life > 0

  update: ->
    @life -= 1
    @move()

  destroy: ->
    @life = 0

  move: ->
    @position.x += @speedVector.x
    @position.y += @speedVector.y
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0
