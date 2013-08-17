require('chai').should()
{World} = require '../server/world'

describe 'World', ->
  world = new World
    limits:
      width: 100, height: 50

  player_id = null
  other_player_id = null

  it 'should have limits', ->
    world.should.have.property 'limits'
    world.limits.width.should.equal 100
    world.limits.height.should.equal 50

  it 'should serialize', ->
    data = world.serialize()
    data.should.have.property 'players'
    data.players.should.be.instanceof Array
    data.should.have.property 'projectiles'
    data.projectiles.should.be.instanceof Array

  it 'should add a player', ->
    {status, id} = world.addPlayer()
    player_id = id
    status.should == 'connected'

  it 'should not list a player if he has not joined', ->
    world.serialize().players.should.be.empty

  it 'should list a player if he has joined and return his color', ->
    color = world.join(player_id, 'Light Fighter')
    color.should.exist
    world.serialize().players.should.not.be.empty

  it 'should update player and list projectiles', ->
    world.setPlayersKeys(player_id, up: true, left: true, fire: true)
    world.update()
    data = world.serialize()
    data.players[0].direction.should.not.equal 0
    data.projectiles.should.not.be.empty

  it 'should remove player', ->
    world.removePlayer(player_id)
    world.serialize().players.should.be.empty
