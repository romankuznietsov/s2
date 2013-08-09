require('chai').should()
{Player} = require '../server/player'
{Shot} = require '../server/shot'
ships = require '../server/ships'

describe 'Player', ->
  ship = ships['light']

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

  createShot = (opts) ->
    {shooter, target} = opts
    new Shot
      position: target.position
      shooter: shooter

  it 'should serialize', ->
    data = player.serialize()
    for attr in ['position', 'direction', 'health', 'color', 'score', 'radius']
      data.should.have.property attr

  it 'should move if keys are pressed', ->
    before = player.serialize()
    player.setKeys up: true, left: true
    player.update()
    before.should.not.equal player.serialize()

  it 'should shoot', ->
    player.setKeys fire: true
    shots = player.getShots()
    shots.length.should.be.greaterThan 0
    shots[0].shooter.should.equal player

  it 'should have a cooldown', ->
    player.getShots().length.should.equal 0

  it 'should loose health when hit and destroy the shot', ->
    shot = createShot(shooter: otherPlayer, target: player)
    player.checkHit(shot).should.equal true
    shot.alive().should.equal false
    player.serialize().health.should.be.lessThan 1

  it 'should respawn when killed', ->
    shot = createShot(shooter: otherPlayer, target: player)
    player.checkHit(shot).should.equal true
    player.serialize().health.should.be.equal 1

  it 'should increase score', ->
    otherPlayer.serialize().score.should.equal 1

  it 'should decrease score on autokill', ->
    player.checkHit(createShot(shooter: player, target: player))
    player.checkHit(createShot(shooter: player, target: player))
    player.serialize().score.should.equal -1
