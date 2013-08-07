require('chai').should()
{Shot} = require '../server/shot'
{EventEmitter} = require 'events'

describe 'Shot', ->
  emitter = new EventEmitter

  shot = new Shot
    emitter: emitter
    position:
      x: 0, y: 0
    limits:
      x: 100, y: 100
    direction: 0

  it 'should serialize', ->
    data = shot.serialize()
    data.should.have.property 'position'

  it 'should update life and position', ->
    emitter.emit 'update'
    shot.position.x.should.be.greaterThan 0
    shot.position.y.should.equal 0
    shot.life.should.equal (shot.lifeLength - 1)
