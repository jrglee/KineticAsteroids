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

  class Bullet
    constructor: ->
      @img = new Kinetic.Shape
        centerOffset:
          x: 4
          y: 4
        drawFunc: ->
          c = @getContext()

          gradient = c.createRadialGradient(4, 4, 0.1, 4, 4, 5)
          gradient.addColorStop(0.1, "rgba(255, 255, 255, 1)")
          gradient.addColorStop(0.4, "rgba(255, 0, 0, 0.6)")
          gradient.addColorStop(1, "rgba(255, 255, 0, 0.1)")

          @setFill(gradient)

          c.beginPath()
          c.arc(4, 4, 5, 0, Math.PI * 2, true)
          c.closePath()
          @fillStroke()

      @velocity = new Vector()

    update: ->


    setVelocity: (scalarVelocity, angle) ->


      # layer to render the ship
  layer = new Kinetic.Layer()

  # ship instance
  ship = null

  bullets =
    pool: []
    used: []
    lastShot: 0

  # functions

  init = ->
    ship = new Ship()
    layer.add ship.shape

    eventbus.updated.add update
    eventbus.accelerated.add accelerate
    eventbus.turned.add turn
    eventbus.shot.add shoot

  getVelocity = -> ship.velocity

  update = ->
    ship.update()
    layer.draw()

  accelerate = (v) ->
    ship.accelerate(v)

  turn = (angle) ->
    ship.shape.rotateDeg(angle)

  shoot = ->
    time = new Date().getTime()

    # enforce shooting interval
    return undefined if time - bullets.lastShot < config.shootInterval
    bullets.lastShot = time

    # create bullet and add to the stage
    console.log "shoot"

    bullet = if bullets.pool.length == 0 then new Bullet() else bullets.pool.pop()

    bullet.img.setX(ship.getPosition().x)
    bullet.img.setY(ship.getPosition().y)

    angle = ship.getAngle()

    bullet.velocity = new Vector(config.bulletSpeed * Math.cos(angle), config.bulletSpeed * Math.sin(angle))

    layer.add bullet.img

    bullets.used.push bullet

  # define return object - revealing module pattern
  init: init
  layer: layer
  velocity: getVelocity