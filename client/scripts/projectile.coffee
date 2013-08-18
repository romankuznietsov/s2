define ->
  class Projectile
    constructor: (params) ->
      for key, value of params
        @[key] = value

    predict: (dt) ->
      true
