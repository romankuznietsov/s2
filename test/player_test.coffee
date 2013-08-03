require('chai').should()
{Player} = require '../server/player'
{Shot} = require '../server/shot'

describe 'Player', ->
  shots = []
  emitShot = (shot) =>
    shots.push shot

  player = new Player
    limits:
      x: 100, y: 100
    emitShot: emitShot
    color: '#fff'

  it 'should update be controlled by keys', ->
    player.updateKeys up: true
    player.update()
    player.speed.should.be.greaterThan 0

    player.updateKeys left: true
    player.update()
    player.direction.should.not.equal 0

  it 'should update position', ->
    player.position.x.should.not.equal 1
    player.position.y.should.not.equal 2

  it 'should serialize', ->
    data = player.serialize()
    for attr in ['position', 'direction', 'health', 'color']
      data.should.have.property attr

  it 'should generate shots', ->
    shots.should.be.empty
    player.updateKeys fire: true
    player.update()
    shots.should.not.be.empty

  it 'should have a cooldown', ->
    shotNumber = shots.length
    player.update()
    shots.length.should.equal shotNumber
    player.cooldown.should.not.equal player.shotCooldown

  it 'should loose health when hit', ->
    player.hit()
    player.health.should.be.lessThan player.maxHealth

  it 'should reset on respawn', ->
    for _ in [1..3]
      player.hit()
    player.update()
    player.health.should.equal player.maxHealth
    player.cooldown.should.equal 0
    player.speed.should.equal 0
    player.direction.should.equal 0
