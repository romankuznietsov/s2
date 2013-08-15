projectiles =
  blast:
    speed: 5
    damage: 1
    life: 400

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

ships =
  light:
    weapon: weapons['Light Blaster']
    acceleration: 0.03
    topSpeed: 3
    turnSpeed: 0.035
    inertia: 20
    maxHealth: 2
    radius: 10

  medium:
    weapon: weapons['Medium Blaster']
    acceleration: 0.02
    topSpeed: 2
    turnSpeed: 0.017
    inertia: 35
    maxHealth: 3
    radius: 14

  heavy:
    weapon: weapons['Heavy Blaster']
    acceleration: 0.01
    topSpeed: 1.8
    turnSpeed: 0.014
    inertia: 45
    maxHealth: 5
    radius: 18

module.exports = ships
