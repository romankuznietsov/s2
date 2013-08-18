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

  update: (dt) ->
    @life -= dt
    @move(dt)

  destroy: ->
    @life = 0

  move: (dt) ->
    @position.x += @speedVector.x * dt
    @position.y += @speedVector.y * dt
    @position.x -= @limits.width if @position.x > @limits.width
    @position.y -= @limits.height if @position.y > @limits.height
    @position.x += @limits.width if @position.x < 0
    @position.y += @limits.height if @position.y < 0
