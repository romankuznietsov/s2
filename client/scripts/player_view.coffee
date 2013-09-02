define ->
  class ShipModelStore
    constructor: ->
      @images = {}

    getModel: (type, color) ->
      if @images[color]
        @images[color]
      else
        @images[color] = new Image
        console.log "ships/#{type}_#{color}.png"
        @images[color].src = "ships/#{type}_#{color}.png"
        @images[color]

  shipModelStore = new ShipModelStore

  (canvas, player) ->
    shieldColor = if player.invincible
      "rgb(255, 255, 0)"
    else
      "rgba(0, 160, 255, #{player.health.toFixed(2)})"

    canvas
      .translateCanvas
        translateX: player.position.x
        translateY: player.position.y
      # .drawArc
      #   strokeStyle: shieldColor
      #   strokeWidth: 1
      #   radius: player.radius
      #   x: 0, y: 0
      .drawImage
        rotate: player.direction + 90
        source: shipModelStore.getModel(player.type, player.color.name)
        x: 0, y: 0
        width: player.radius * 2
        height: player.radius * 2
      .restoreCanvas()
