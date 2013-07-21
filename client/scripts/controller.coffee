require ['gamepad', '../socket.io-client/dist/socket.io.min'], (Gamepad, SocketIo) ->
  gamepad = new Gamepad
  keySending = null
  sendInterval = 32

  socket = SocketIo.connect window.location.origin, query: 'role=controller'

  sendKeys = ->
    socket.emit 'keys', gamepad.keys

  setIndicatorColor = (color) ->
    $('.color-indicator').css('background-color', color || 'transparent')

  setInfoText = (text) ->
    $('.info').html(text || '')

  socket.on 'connected', (color) ->
    keySending = setInterval(sendKeys, sendInterval)
    setInfoText()
    setIndicatorColor(color)

  socket.on 'disconnect', () ->
    setIndicatorColor()
    setInfoText('Disconnected')
    keySending && clearInterval(keySending)
