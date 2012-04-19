define ->
  class Vector
    constructor: (@x = 0, @y = 0) ->

    add: (vec) ->
      new Vector(@x + vec.x, @y + vec.y)

    subtract: (vec) ->
      new Vector(@x - vec.x, @y - vec.y)

    multiply: (n) ->
      new Vector(@x * n, @y * n)

    length: ->
      Math.sqrt(Math.pow(@x, 2) + Math.pow(@y, 2))

    normalize: ->
      a = Math.atan2(@y, @x)
      new Vector(Math.cos(a), Math.sin(a))

    clone: ->
      new Vector(@x, @y)

    toString: ->
      "#{@x},#{@y}"