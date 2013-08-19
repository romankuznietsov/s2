require ['gamepad', '../socket.io-client/dist/socket.io.min'], (Gamepad, SocketIo) ->
  class Controller
    sendInterval: 32
    constructor: ->
      @gamepad = new Gamepad
      @menu = $('#menu')
      @controller = $('#controller')
      @shipList = $('#menu .ship-list')
      @hud = $('.hud')
      @setInfoText('Connecting')
      @connect()

    connect: ->
      @socket = SocketIo.connect window.location.origin,
        query: 'role=controller'
      @socket.on 'ships', @showShips
      @socket.on 'join', @join
      @socket.on 'disconnect', @disconnect
      @socket.on 'update', @update

    showShips: (ships) =>
      @setInfoText('Select a ship')
      for name, props of ships
        $('<a>').attr('href', '').html(name).addClass('ship').appendTo(@shipList)
      @shipList.delegate 'a.ship', 'touchend click', (e) =>
        @socket.emit 'selectShip', e.target.innerHTML
        false

    clearShips: ->
      @shipList.empty()

    setIndicatorColor: (color) ->
      $('.color-indicator').css('background-color', color || 'transparent')

    setInfoText: (text) ->
      $('.info-line').html(text || '')

    join: (color) =>
      @switchToController()
      @keySending = setInterval(@sendKeys, @sendInterval)
      @setIndicatorColor(color)

    disconnect: =>
      @keySending && clearInterval(@keySending)
      @clearShips()
      @switchToMenu()
      @setInfoText('Disconnected')

    sendKeys: =>
      @socket.emit 'keys', @gamepad.keys

    update: (stats) =>
      @hud.html "Shield: #{stats.health.toFixed(0)}%<br/>Frags: #{stats.score}"

    switchToController: ->
      @menu.hide()
      @controller.show()

    switchToMenu: ->
      @controller.hide()
      @menu.show()

  $ ->
    new Controller
