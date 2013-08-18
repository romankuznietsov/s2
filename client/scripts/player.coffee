define ->
  class Player
    constructor: (params) ->
      for key, value of params
        @[key] = value

    predict: (dt) ->
      true

