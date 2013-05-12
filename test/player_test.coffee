chai = require 'chai'
chai.should()
{Player} = require '../app/scripts/player'
{Shot} = require '../app/scripts/shot'

describe 'Player', ->
  player = new Player
    position:
      x: 1, y: 2
    direction: 30

  it 'should update be controlled by keys', ->
    player.updateKeys up: true
    player.update()
    player.speed.should.be.greaterThan 0

    player.updateKeys left: true
    player.update()
    player.direction.should.be.lessThan 30

  it 'should update position', ->
    player.position.x.should.not.equal 1
    player.position.y.should.not.equal 2

  it 'should serialize', ->
    data = player.serialize()
    for attr in ['id', 'position', 'direction', 'health']
      data.should.have.property attr

  it 'should generate shots', ->
    player.updateKeys fire: true
    shots = player.getShots()
    shots.length.should.not.be.empty
    shots[0].should.be.instanceof Shot

  it 'should have a cooldown', ->
    player.getShots().should.be.empty
    player.update()
    player.cooldown.should.not.equal player.shotCooldown

  it 'should loose health when hit', ->
    player.hit()
    player.health.should.be.lessThan player.maxHealth

  it 'should reset on respawn', ->
    player.respawn x: 0, y: 0
    player.health.should.equal player.maxHealth
    player.cooldown.should.equal 0
    player.speed.should.equal 0
    player.direction.should.equal 0
    player.position.x.should.equal 0
    player.position.y.should.equal 0
