define ->
  drawBlast = (canvas, projectile) ->
    canvas.drawArc
      fillStyle: '#ff0'
      x: projectile.position.x
      y: projectile.position.y
      radius: 2

  drawBullet = (canvas, projectile) ->
    canvas.drawLine
      strokeStyle: '#ff0'
      strokeWidth: 1
      x1: projectile.position.x
      y1: projectile.position.y
      x2: projectile.position.x + projectile.speedVector.x / 100
      y2: projectile.position.y + projectile.speedVector.y / 100

  (canvas, projectile) ->
    switch projectile.type
      when 'blast' then drawBlast(canvas, projectile)
      when 'bullet' then drawBullet(canvas, projectile)
      else drawBlast(canvas, projectile)
