define ->
  class Vector
    constructor: (@x, @y) ->

    add: (vec) ->
      new Vector(@x + vec.x, @y + vec.y)

    subtract: (vec) ->
      new Vector(@x - vec.x, @y - vec.y)

    multiply: (n) ->
      new Vector(@x * n, @y * n)

    clone: ->
      new Vector(@x, @y)