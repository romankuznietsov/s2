require('chai').should()
{Player} = require '../server/player'
{Projectile} = require '../server/projectile'
ships = require '../server/ships'

describe 'Player', ->
  ship = ships['Light Fighter']

  player = new Player
    limits:
      width: 100, height: 100
    color: '#fff'
    ship: ship

  otherPlayer = new Player
    limits:
      width: 100, height: 100
    color: '#fff'
    ship: ship

  createProjectile = (opts) ->
    {shooter, target} = opts
    new Projectile(
      {speed: 1, damage: 1, life: 3},
      {shooter: shooter, position: target.position, limits: {width: 100, height: 100}},
      direction: 1
    )

  it 'should serialize', ->
    data = player.serialize()
    for attr in ['position', 'direction', 'health', 'color', 'score', 'radius']
      data.should.have.property attr

  it 'should move if keys are pressed', ->
    before = player.serialize()
    player.setKeys up: true, left: true
    player.update(10)
    before.should.not.equal player.serialize()

  it 'should shoot', ->
    player.setKeys fire: true
    projectiles = player.getProjectiles()
    projectiles.length.should.be.greaterThan 0
    projectiles[0].shooter.should.equal player

  it 'should loose health when hit and destroy the projectile', ->
    projectile = createProjectile(shooter: otherPlayer, target: player)
    player.checkHit(projectile).should.equal true
    projectile.alive().should.equal false
    player.serialize().health.should.be.lessThan 1

  it 'should respawn when killed', ->
    projectile = createProjectile(shooter: otherPlayer, target: player)
    player.checkHit(projectile).should.equal true
    player.serialize().health.should.be.equal 1

  it 'should be invincible after respawn', ->
    projectile = createProjectile(shooter: otherPlayer, target: player)
    player.checkHit(projectile).should.equal true
    player.serialize().health.should.be.equal 1

  it 'should increase score', ->
    otherPlayer.serialize().score.should.equal 1

  it 'should decrease score on autokill', ->
    player.update(10)
    player.checkHit(createProjectile(shooter: player, target: player))
    player.checkHit(createProjectile(shooter: player, target: player))
    player.serialize().score.should.equal -1
