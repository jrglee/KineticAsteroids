define [
  "kinetic"
  "cs!vector"
  "cs!config"
  "cs!eventbus"
  "cs!ship"
], (Kinetic, Vector, config, eventbus, ship) ->
  maxWidth = 800
  maxHeight = 600

  class StarGroup
    constructor: (quantity, args) ->
      @stars = [0..quantity].map -> new Star args
      @velocityRatio = args.velocityRatio

    update: (vel) ->
      velocity = vel.multiply -@velocityRatio

      @stars.forEach (star) ->
        pos = star.getPosition().add(velocity)

        x = pos.x
        y = pos.y

        if x < 0
          x = maxWidth - x
        else if x > maxWidth
          x -= maxWidth

        if y < 0
          y = maxHeight - y
        else if y > maxHeight
          y -= maxHeight

        star.setPosition new Vector x, y

  class Star
    constructor: (args) ->
      @kineticStar = new Kinetic.Star
        points: args.points
        outerRadius: args.outerRadius
        innerRadius: args.innerRadius
        rotation: Math.random() * Math.PI * 2
        fill: args.color
        alpha: args.alpha
        x: Math.round Math.random() * maxWidth
        y: Math.round Math.random() * maxHeight

      @velocityRatio = args.velocityRatio

    setPosition: (vec) ->
      @kineticStar.setX(vec.x)
      @kineticStar.setY(vec.y)

    getPosition: ->
      new Vector @kineticStar.attrs.x, @kineticStar.attrs.y

  layer = new Kinetic.Layer()

  background = foreground = null

  init = ->
    maxWidth = config.width * config.backgroundRatio
    maxHeight = config.height * config.backgroundRatio

    # determine number of stars based on available screen size
    ratio = Math.floor(maxWidth * maxHeight / 20000)

    # add background stars
    background = new StarGroup ratio * 3,
      points: 5
      outerRadius: 3
      innerRadius: 1
      color: "white"
      alpha: 0.5
      velocityRatio: 0.1

    # add foreground stars
    foreground = new StarGroup ratio,
      points: 6
      outerRadius: 4
      innerRadius: 2
      color: "white"
      alpha: 0.8
      velocityRatio: 1 / 6

    # add all stars to layer to be rendered
    background.stars.concat(foreground.stars).forEach (star) ->
      layer.add star.kineticStar

    # subscribe to update events
    eventbus.updated.add update

  update = ->
    vel = ship.velocity()

    background.update(vel)
    foreground.update(vel)

    layer.draw()

  # define return object - revealing module pattern
  init: init
  layer: layer