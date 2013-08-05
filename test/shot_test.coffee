require('chai').should()
{Shot} = require '../server/shot'
{EventEmitter} = require 'events'

describe 'Shot', ->
  emitter = new EventEmitter

  player1 =
    hit: -> true

  player2 =
    hit: -> true

  shot = new Shot
    emitter: emitter
    position:
      x: 0, y: 0
    limits:
      x: 100, y: 100
    direction: 0
    player: player1

  it 'should serialize', ->
    data = shot.serialize()
    data.should.have.property 'position'

  it 'should update life and position', ->
    emitter.emit 'update'
    shot.position.x.should.equal shot.scalarSpeed
    shot.position.y.should.equal 0
    shot.life.should.equal (shot.lifeLength - 1)

  it 'should call frag if killed a player', (done) ->
    player1.frag = done
    shot.hit(player2)

  it 'should call selfFrag if killed own player', (done) ->
    delete player1.frag
    player1.autoFrag = done
    shot.hit(player1)


