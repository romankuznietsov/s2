require('chai').should()
{Projectile} = require '../server/projectile'

describe 'Projectile', ->
  shooter = {foo: 'bar'}
  projectile = new Projectile(
    { speed: 5, damage: 1, life: 100 },
    {
      position:
        x: 0, y: 0
      limits:
        width: 100, height: 100
      shooter: shooter
    }, 0
  )

  it 'should serialize', ->
    data = projectile.serialize()
    data.should.have.property 'position'

  it 'should update life and position', ->
    projectile.update()
    state = projectile.serialize()
    state.position.x.should.be.greaterThan 0
    state.position.y.should.equal 0

  it 'should be alive', ->
    projectile.alive().should.equal true
    projectile.destroy()
    projectile.alive().should.equal false

  it 'should have a shooter', ->
    projectile.shooter.should.equal shooter
