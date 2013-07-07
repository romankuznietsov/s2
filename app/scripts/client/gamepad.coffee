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
      $(event.target).addClass('active')
      action = $(event.target).attr('action')
      @keys[action] = true
      false
    keyUp: (event) =>
      $(event.target).removeClass('active')
      action = $(event.target).attr('action')
      @keys[action] = false
      false
