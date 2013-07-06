require ['gamepad', 'config'], (Gamepad, config) ->
  ws = new WebSocket config.wsServer, 'controller'

  gamepad = new Gamepad
  keySending = null
  sendInterval = 32

  sendKeys = ->
    ws.send JSON.stringify(gamepad.keys)

  ws.onopen = ->
    keySending = setInterval(sendKeys, sendInterval)

  ws.onmessage = (message) ->
    $('.info').html "Player #{message.data}"

  ws.onclose = ->
    keySending && clearInterval(keySending)
