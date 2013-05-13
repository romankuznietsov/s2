require ['gamepad'], (Gamepad) ->
  wsPort = 3001
  wsServerPath = "ws://#{window.location.hostname}:#{wsPort}"
  ws = new WebSocket wsServerPath, 'controller'

  gamepad = new Gamepad
  keySending = null
  sendInterval = 32

  sendKeys = ->
    ws.send JSON.stringify(gamepad.keys)

  ws.onopen = ->
    keySending = setInterval(sendKeys, sendInterval)

  ws.onclose = ->
    keySending && clearInterval(keySending)
