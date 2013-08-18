projectiles =
  blast:
    type: 'blast'
    range: 750
    speed: 500
    damage: 1

  bullet:
    type: 'bullet'
    range: 500
    speed: 1000
    damage: 0.3

weapons =
  'Light Blaster':
    projectile: projectiles.blast
    spread: 0.05
    projectilesPerShot: 1
    cooldown: 0.4

  'Medium Blaster':
    projectile: projectiles.blast
    spread: 0.06
    projectilesPerShot: 1
    cooldown: 0.3

  'Heavy Blaster':
    projectile: projectiles.blast
    spread: 0.07
    projectilesPerShot: 1
    cooldown: 0.2

  'Machine Gun':
    projectile: projectiles.bullet
    spread: 0.03
    projectilesPerShot: 1
    cooldown: 0.1

ships =
  'Light Fighter':
    weapon: weapons['Light Blaster']
    acceleration: 300
    topSpeed: 300
    turnSpeed: 3.5
    inertia: 0.20
    maxHealth: 2
    radius: 10

  'Firefly':
    weapon: weapons['Machine Gun']
    acceleration: 250
    topSpeed: 250
    turnSpeed: 2.5
    inertia: 0.25
    maxHealth: 2.5
    radius: 12

  'Medium Fighter':
    weapon: weapons['Medium Blaster']
    acceleration: 200
    topSpeed: 200
    turnSpeed: 1.7
    inertia: 0.35
    maxHealth: 3
    radius: 14

  'Heavy Fighter':
    weapon: weapons['Heavy Blaster']
    acceleration: 100
    topSpeed: 180
    turnSpeed: 1.4
    inertia: 0.45
    maxHealth: 5
    radius: 18

module.exports = ships
