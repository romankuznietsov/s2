require ['screen', '../socket.io-client/dist/socket.io.min'], (Screen, SocketIo) ->

  class ScreenClient
    redrawPeriod: 32
    statusBarHeight: 30

    constructor: ->
      @screen = new Screen
      @connect()

    connect: ->
      @socket = SocketIo.connect window.location.origin,
        query: 'role=screen'
      @socket.on 'limits', @screen.setLimits
      @socket.on 'update', @screen.update
      @socket.on 'disconnected', @disconnect

    disconnect: ->
      console.log 'disconnected'

  $ ->
    new ScreenClient
