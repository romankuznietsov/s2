require('chai').should()
{Player} = require '../server/player'
{Shot} = require '../server/shot'
{EventEmitter} = require 'events'

describe 'Player', ->
  emitter = new EventEmitter

  player = new Player
    limits:
      width: 100, height: 100
    emitter: emitter
    color: '#fff'

  player.join()

  it 'should update and be controlled by keys', ->
    player.setKeys up: true, left: true
    emitter.emit 'update'
    player.speed.should.be.greaterThan 0
    player.direction.should.not.equal 0

  it 'should update position', ->
    {x, y} = player.position
    emitter.emit 'update'
    player.position.should.not.equal {x, y}

  it 'should serialize', ->
    data = player.serialize()
    for attr in ['position', 'direction', 'health', 'color', 'score']
      data.should.have.property attr

  it 'should generate shots', (done) ->
    player.setKeys fire: true
    emitter.once 'shots', -> done()
    emitter.emit 'update'

  it 'should have a cooldown', ->
    emitter.emit 'update'
    player.cooldown.should.be.greaterThan 0
    player.cooldown.should.be.lessThan player.shotCooldown

  it 'should loose health when hit', ->
    player.hit(player, 1)
    player.health.should.be.lessThan player.maxHealth

  it 'should reset on respawn', ->
    player.hit(player, player.maxHealth)
    player.health.should.equal player.maxHealth
    player.cooldown.should.equal 0
    player.speed.should.equal 0
    player.direction.should.equal 0
