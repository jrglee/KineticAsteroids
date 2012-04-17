define ["lib/kinetic", "config", "eventbus"], (Kinetic, config, eventbus) ->
  class Star
    constructor: (args) ->
      @kineticStar = new Kinetic.Star
        points: args.points
        outerRadius: args.outerRadius
        innerRadius: args.innerRadius
        x: Math.random() * config.width * config.backgroundRatio
        y: Math.random() * config.height * config.backgroundRatio
        rotation: Math.random() * Math.PI * 2
        fill: args.color
        alpha: args.alpha

      @velocityRatio = args.velocityRatio

    update: (velocity) ->
      newPosition = util.adjustScreenPosition
        position: @getPosition().add(velocity.multiply(@velocityRatio))
        width: config.width
        height: config.height

      @setPosition newPosition

    getPosition: ->
      new Vector(@kineticStar.attrs.x, @kineticStar.attrs.y)

    setPosition: (vec) ->
      @kineticStar.attrs.x = vec.x
      @kineticStar.attrs.y = vec.y

  layer = new Kinetic.Layer()

  stars = []

  # add background stars
  [0...400].forEach ->
    stars.push new Star
      points: 5
      outerRadius: 3
      innerRadius: 1
      color: "white"
      alpha: 0.5
      velocityRatio: 0.1

  # add foreground stars
  [0...100].forEach ->
    stars.push new Star
      points: 6
      outerRadius: 4
      innerRadius: 2
      color: "white"
      alpha: 0.8
      velocityRatio: 1 / 6

  stars.forEach (star) =>
    layer.add star.kineticStar
  #
  #  move = (vec) =>
  #    stars.forEach (star) ->
  #      star.update vec
  #
  #    @pendingChanges = true
  #
  #
  #  @registerSignals = (signals) ->
  #    signals.shipMoved.add move

  layer: layer