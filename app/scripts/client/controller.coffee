require ['gamepad', '../socket.io-client/dist/socket.io.min'], (Gamepad, SocketIo) ->
  gamepad = new Gamepad
  keySending = null
  sendInterval = 32

  socket = SocketIo.connect window.location.origin, query: 'role=controller'

  sendKeys = ->
    socket.emit 'keys', gamepad.keys

  socket.on 'id', (id) ->
    keySending = setInterval(sendKeys, sendInterval)
    $('.info').html id

  socket.on 'disconnect', ->
    keySending && clearInterval(keySending)
