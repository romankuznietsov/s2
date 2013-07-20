require ['gamepad', 'config', '../socket.io-client/dist/socket.io.min'], (Gamepad, config, SocketIo) ->
  gamepad = new Gamepad
  keySending = null
  sendInterval = 32

  socket = SocketIo.connect config.socketIo, query: 'role=controller'

  sendKeys = ->
    socket.emit 'keys', gamepad.keys

  socket.on 'id', (id) ->
    keySending = setInterval(sendKeys, sendInterval)
    $('.info').html id

  socket.on 'disconnect', ->
    keySending && clearInterval(keySending)
