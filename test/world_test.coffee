require('chai').should()
{World} = require '../server/world'

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
    {status, id, color} = world.addPlayer()
    world.players.should.have.property id
    world.colors.length.should.equal 7

  it 'should remove player', ->
    world.removePlayer(id)
    world.players.should.not.have.property id
    world.colors.length.should.equal 8

  it 'should serialize itself', ->
    data = world.serialize()
    data.should.have.property 'players'
    data.players.should.be.instanceof Array
    data.should.have.property 'shots'
    data.shots.should.be.instanceof Array

  it 'should have shots if a player shoots', ->
    {status, id, color} = world.addPlayer()
    world.join(id, {})
    world.setPlayersKeys(id, fire: true)
    world.update()
    world.shots.should.not.be.empty

  it 'should remove dead shots', ->
    for shot in world.shots
      shot.life = 0
    world.update()
    world.shots.should.be.empty
