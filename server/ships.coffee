projectiles =
  blast:
    type: 'blast'
    range: 750
    speed: 5
    damage: 1

  bullet:
    type: 'bullet'
    range: 500
    speed: 10
    damage: 0.3

weapons =
  'Light Blaster':
    projectile: projectiles.blast
    spread: 0.05
    projectilesPerShot: 1
    cooldown: 40

  'Medium Blaster':
    projectile: projectiles.blast
    spread: 0.06
    projectilesPerShot: 1
    cooldown: 30

  'Heavy Blaster':
    projectile: projectiles.blast
    spread: 0.07
    projectilesPerShot: 1
    cooldown: 20

  'Machine Gun':
    projectile: projectiles.bullet
    spread: 0.03
    projectilesPerShot: 1
    cooldown: 10

ships =
  'Light Fighter':
    weapon: weapons['Light Blaster']
    acceleration: 0.03
    topSpeed: 3
    turnSpeed: 0.035
    inertia: 20
    maxHealth: 2
    radius: 10

  'Firefly':
    weapon: weapons['Machine Gun']
    acceleration: 0.025
    topSpeed: 2.5
    turnSpeed: 0.025
    inertia: 25
    maxHealth: 2.5
    radius: 12

  'Medium Fighter':
    weapon: weapons['Medium Blaster']
    acceleration: 0.02
    topSpeed: 2
    turnSpeed: 0.017
    inertia: 35
    maxHealth: 3
    radius: 14

  'Heavy Fighter':
    weapon: weapons['Heavy Blaster']
    acceleration: 0.01
    topSpeed: 1.8
    turnSpeed: 0.014
    inertia: 45
    maxHealth: 5
    radius: 18

module.exports = ships
