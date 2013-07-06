define ->
  class Gamepad
    constructor: ->
      @keys = {}
      $ =>
        $(document).delegate '.key', 'touchstart', @keyDown
        $(document).delegate '.key', 'touchend', @keyUp
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
