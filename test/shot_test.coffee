require('chai').should()
{Shot} = require '../server/shot'

describe 'Shot', ->
  shooter = {foo: 'bar'}
  shot = new Shot
    position:
      x: 0, y: 0
    limits:
      x: 100, y: 100
    direction: 0
    shooter: shooter

  it 'should serialize', ->
    data = shot.serialize()
    data.should.have.property 'position'

  it 'should update life and position', ->
    shot.update()
    state = shot.serialize()
    state.position.x.should.be.greaterThan 0
    state.position.y.should.equal 0

  it 'should be alive', ->
    shot.alive().should.equal true
    shot.destroy()
    shot.alive().should.equal false

  it 'should have a shooter', ->
    shot.shooter.should.equal shooter
