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

    accelerate: (acceleration) ->
      # determine angle of movement
      a = @getAngle()

      # convert acceleration into a vector and add to velocity
      vel = @velocity.add(new Vector(acceleration * Math.cos(a), acceleration * Math.sin(a)))

      # set max velocity if needed
      vel = vel.normalize().multiply(config.maxSpeed) if vel.length() > config.maxSpeed

      # update velocity attribute with new calculated vector
      @velocity = vel

    getPosition: ->
      new Vector @shape.attrs.x, @shape.attrs.y

    setPosition: (vec) ->
      @shape.attrs.x = vec.x
      @shape.attrs.y = vec.y

    getAngle: ->
      @shape.getRotation() + Math.PI * 3 / 2

  # layer to render the ship
  layer = new Kinetic.Layer()

  # ship instance
  ship = null

  # function

  init = ->
    ship = new Ship()
    layer.add ship.shape

    eventbus.updated.add update
    eventbus.accelerated.add accelerate
    eventbus.turned.add turn

  getVelocity = -> ship.velocity

  update = ->
    ship.update()
    layer.draw()

  accelerate = (v) ->
    ship.accelerate(v)

  turn = (angle) ->
    ship.shape.rotateDeg(angle)

  # define return object - revealing module pattern
  init: init
  layer: layer
  velocity: getVelocity