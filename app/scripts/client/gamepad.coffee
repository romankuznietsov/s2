define ->
  class Gamepad
    constructor: ->
      @keys = {}
      $ =>
        $(document).delegate '.control', 'touchstart', @keyDown
        $(document).delegate '.control', 'touchend', @keyUp
        $(document).delegate 'body', 'touchstart', -> false
        $(document).delegate 'body', 'touchend', -> false
    keyDown: (event) =>
      action = $(event.target).attr('action')
      @keys[action] = true
      false
    keyUp: (event) =>
      action = $(event.target).attr('action')
      @keys[action] = false
      false
