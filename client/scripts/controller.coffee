require ['gamepad', '../socket.io-client/dist/socket.io.min'], (Gamepad, SocketIo) ->
  class Controller
    sendInterval: 32
    constructor: ->
      @gamepad = new Gamepad
      @connect()

    connect: ->
      @socket = SocketIo.connect window.location.origin,
        query: 'role=controller'
      @socket.on 'ships', @showShips
      @socket.on 'join', @join
      @socket.on 'disconnect', @disconnect

    showShips: (ships) =>
      list = $('#ship-select')
      for name, props of ships
        $('<a href="">').html(name).appendTo(list)
      list.delegate 'a', 'touchend', (e) =>
        @socket.emit 'selectShip', e.target.innerHTML
        false
      list.delegate 'a', 'click', (e) =>
        @socket.emit 'selectShip', e.target.innerHTML
        false

    setIndicatorColor: (color) ->
      $('.color-indicator').css('background-color', color || 'transparent')

    setInfoText: (text) ->
      $('.info').html(text || '')

    join: (color) =>
      $('#ship-select').hide()
      $('#controller').show()
      @keySending = setInterval(@sendKeys, @sendInterval)
      @setInfoText()
      @setIndicatorColor(color)

    disconnect: =>
      @setIndicatorColor()
      @setInfoText('Disconnected')
      @keySending && clearInterval(@keySending)

    sendKeys: =>
      @socket.emit 'keys', @gamepad.keys

  $ ->
    new Controller
