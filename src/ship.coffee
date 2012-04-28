define ["lib/kinetic", "vector", "config", "util", "eventbus"], (Kinetic, Vector, config, util, eventbus) ->
  class Ship
    constructor: ->
      @shape = new Kinetic.Shape
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

      @position = new Vector(config.width / 2, config.height / 2)
      @velocity = new Vector(0, -2)

    update: ->
      @setPosition util.adjustScreenPosition
        position: @position.add @velocity
        width: config.width
        height: config.height

    accelerate: (accel) ->
      # convert acceleration into a vector and add to velocity
      vel = @velocity.add(Vector.fromScalar(accel, @getAngle()))

      # set max velocity if needed
      vel = vel.normalize().multiply(config.maxSpeed) if vel.length() > config.maxSpeed

      # update velocity attribute with new calculated vector
      @velocity = vel

    setPosition: (vec) ->
      @position = vec
      @shape.setX(vec.x)
      @shape.setY(vec.y)

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

      @position = new Vector()
      @velocity = new Vector()

    setPosition: (v) ->
      @position = v
      @img.setX(v.x)
      @img.setY(v.y)
      @

    update: ->
      @setPosition @position.add(@velocity)

  layer = new Kinetic.Layer()

  # ship instance
  ship = null

  bullets =
    pool: []
    used: []
    lastShot: 0
    update: ->
      remaining = []
      @used.forEach (bullet) =>
        bullet.update()

        if bullet.position.x < 0 ||
        bullet.position.x > config.width ||
        bullet.position.y < 0 ||
        bullet.position.y > config.height
          @pool.push bullet

          # remove from layer
          layer.remove(bullet.img)
        else
          remaining.push bullet

      @used = remaining

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
    bullets.update()
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

    bullet.setPosition Vector.fromScalar(12, ship.getAngle()).add(ship.position)
    bullet.velocity = Vector.fromScalar(config.bulletSpeed, ship.getAngle())

    layer.add bullet.img

    bullets.used.push bullet

  # define return object - revealing module pattern
  init: init
  layer: layer
  velocity: getVelocity