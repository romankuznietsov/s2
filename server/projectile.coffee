exports.Projectile =
class Projectile
  constructor: (params, shooterParams, direction) ->
    {speed, range, @damage} = params
    @life = range / speed
    {@shooter, @position, @limits} = shooterParams
    @speedVector =
      x: Math.cos(direction) * speed
      y: Math.sin(direction) * speed
    @lifeLeft = @life

  serialize: ->
    position: @position

  alive: ->
    @lifeLeft > 0

  update: ->
    @lifeLeft -= 1
    @move()

  destroy: ->
    @lifeLeft = 0

  move: ->
    @position.x += @speedVector.x
    @position.y += @speedVector.y
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0
