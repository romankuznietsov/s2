define ->
  class KeyWatcher
    constructor: ->
      @keys = {}
      $(document).keydown @keydown
      $(document).keyup @keyup
    set: (code, value) ->
      switch code
        when 37
          @keys.left = value
        when 38
          @keys.up = value
        when 39
          @keys.right = value
        when 40
          @keys.down = value
        when 32
          @keys.space = value
        else
          return
      false
    status: ->
      @keys
    keyup: (e) =>
      @set(e.keyCode, false)
    keydown: (e) =>
      @set(e.keyCode, true)
