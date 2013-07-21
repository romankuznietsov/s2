require('chai').should()
{World} = require '../app/scripts/world'

describe 'World', ->
  world = new World
    limits:
      width: 100, height: 50
  id = null

  it 'should have limits', ->
    world.should.have.property 'limits'
    world.limits.width.should.equal 100
    world.limits.height.should.equal 50

  it 'should add a player', ->
    id = world.addPlayer()
    world.players.should.have.property id

  it 'should remove player', ->
    world.removePlayer(id)
    world.players.should.not.have.property id

  it 'should serialize itself', ->
    data = world.serialize()
    data.should.have.property 'players'
    data.players.should.be.instanceof Array
    data.should.have.property 'shots'
    data.shots.should.be.instanceof Array

  it 'should limit position', ->
    object =
      position:
        x: -10, y: -10
    world.limitPosition(object)
    object.position.x.should.equal world.limits.width - 10
    object.position.y.should.equal world.limits.height - 10

  it 'should have shots if a player shoots', ->
    id = world.addPlayer()
    world.updatePlayersKeys(id, fire: true)
    world.update()
    world.shots.should.not.be.empty

  it 'should remove dead shots', ->
    for shot in world.shots
      shot.hitShip()
    world.update()
    world.shots.should.be.empty

  it 'should generate random position', ->
    position = world.randomPosition()
    position.x.should.be.a 'number'
    position.y.should.be.a 'number'
