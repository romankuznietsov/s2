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

  it 'should update be controlled by keys', ->
    player.updateKeys up: true, left: true
    emitter.emit 'update'
    player.speed.should.be.greaterThan 0
    player.direction.should.not.equal 0

  it 'should update position', ->
    {x, y} = player.position
    emitter.emit 'update'
    player.position.should.not.equal {x, y}

  it 'should serialize', ->
    data = player.serialize()
    for attr in ['position', 'direction', 'health', 'color']
      data.should.have.property attr

  it 'should generate shots', (done) ->
    player.updateKeys fire: true
    emitter.once 'shots', -> done()
    emitter.emit 'update'

  it 'should have a cooldown', ->
    emitter.emit 'update'
    player.cooldown.should.not.equal player.shotCooldown

  it 'should loose health when hit', ->
    player.hit()
    player.health.should.be.lessThan player.maxHealth

  it 'should reset on respawn', ->
    for _ in [1..3]
      player.hit()
    emitter.emit 'update'
    player.health.should.equal player.maxHealth
    player.cooldown.should.equal 0
    player.speed.should.equal 0
    player.direction.should.equal 0
