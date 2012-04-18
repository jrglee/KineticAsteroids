define ["lib/kinetic", "vector", "config", "util", "eventbus"], (Kinetic, Vector, config, util, eventbus) ->
  class Ship
    constructor: ->
      @shape = new Kinetic.Shape
        x: config.width / 2
        y: config.height / 2
        centerOffset:
          x: 8
          y: 12
        drawFunc: ->
          ctx = @getContext()
          ctx.beginPath()
          ctx.moveTo(8, 0)
          ctx.lineTo(16, 21)
          ctx.quadraticCurveTo(8, 10, 0, 21)
          ctx.closePath()
          @fillStroke()
        fill: "E3E186"
        stroke: "green"
        strokeWidth: 1

      @velocity = new Vector(0, -2)

    update: ->
      @setPosition util.adjustScreenPosition
        position: @getPosition().add(@velocity)
        width: config.width
        height: config.height

    getPosition: ->
      new Vector @shape.attrs.x, @shape.attrs.y

    setPosition: (vec) ->
      @shape.attrs.x = vec.x
      @shape.attrs.y = vec.y

  layer = new Kinetic.Layer()

  # declare ship here to make it available to other functions
  ship = null

  init = ->
    ship = new Ship()
    layer.add ship.shape

    eventbus.updated.add ->
      ship.update()
      layer.draw()

  getVelocity = -> ship.velocity

  # define return object - revealing module pattern
  init: init
  layer: layer
  velocity: getVelocity