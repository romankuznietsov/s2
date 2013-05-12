chai = require 'chai'
chai.should()
{Shot} = require '../app/scripts/shot'

describe 'Shot', ->
  shot = new Shot
    position:
      x: 0, y: 0
    direction: 0

  it 'should serialize', ->
    data = shot.serialize()
    data.should.have.property 'position'

  it 'should be dead after hit', ->
    shot.hitShip()
    shot.dead().should.be.true

  it 'should update life and position', ->
    shot.update()
    shot.position.x.should.equal shot.scalarSpeed
    shot.position.y.should.equal 0
    shot.life.should.equal (shot.lifeLength - 1)
