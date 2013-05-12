require ['gamepad'], (Gamepad) ->
  gamepad = new Gamepad
  ws = new WebSocket 'ws://romankuznietsov.asuscomm.com:3001', 'controller'
  keyInterval = null

  sendKeys = ->
    ws.send JSON.stringify(gamepad.keys)

  ws.onopen = ->
    keyInterval = setInterval(sendKeys, 10)

  ws.onclose = ->
    keyInterval && clearInterval(keyInterval)
