define ["lib/kinetic", "vector", "config", "eventbus", "ship"], (Kinetic, Vector, config, eventbus, ship) ->
  maxWidth = config.width * config.backgroundRatio
  maxHeight = config.height * config.backgroundRatio

  class Star
    constructor: (args) ->
      @kineticStar = new Kinetic.Star
        points: args.points
        outerRadius: args.outerRadius
        innerRadius: args.innerRadius
        rotation: Math.random() * Math.PI * 2
        fill: args.color
        alpha: args.alpha

      @position = new Vector(Math.random() * maxWidth, Math.random() * maxHeight)
      @velocityRatio = args.velocityRatio

    update: (velocity) ->
      pos = @position.add velocity.multiply(-@velocityRatio)

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

      @setPosition new Vector(x, y)

    setPosition: (vec) ->
      @position = vec
      @kineticStar.setX(vec.x)
      @kineticStar.setY(vec.y)

  layer = new Kinetic.Layer()

  stars = []

  init = ->
    # determine number of stars based on available screen size
    ratio = Math.floor(maxWidth * maxHeight / 20000)

    # add background stars
    [0... ratio * 3].forEach ->
      stars.push new Star
        points: 5
        outerRadius: 3
        innerRadius: 1
        color: "white"
        alpha: 0.5
        velocityRatio: 0.1

    # add foreground stars
    [0... ratio].forEach ->
      stars.push new Star
        points: 6
        outerRadius: 4
        innerRadius: 2
        color: "white"
        alpha: 0.8
        velocityRatio: 1 / 6

    # add all stars to layer to be rendered
    stars.forEach (star) ->
      layer.add star.kineticStar

    # subscribe to update events
    eventbus.updated.add update

  update = ->
    vel = ship.velocity()

    stars.forEach (star) ->
      star.update vel

    layer.draw()

  # define return object - revealing module pattern
  init: init
  layer: layer