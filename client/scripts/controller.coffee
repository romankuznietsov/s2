require ['gamepad', '../socket.io-client/dist/socket.io.min'], (Gamepad, SocketIo) ->
  class Controller
    sendInterval: 32
    constructor: ->
      @gamepad = new Gamepad
      @connect()

    connect: ->
      @socket = SocketIo.connect window.location.origin,
        query: 'role=controller'
      @socket.on 'connected', @connected
      @socket.on 'disconnect', @disconnect

    setIndicatorColor: (color) ->
      $('.color-indicator').css('background-color', color || 'transparent')

    setInfoText: (text) ->
      $('.info').html(text || '')

    connected: (color) =>
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
