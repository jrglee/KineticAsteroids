define ["lib/kinetic", "vector", "config", "eventbus", "ship", "util"], (Kinetic, Vector, config, eventbus, ship, util) ->
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

      # invert velocity for opposite movement
      @velocityRatio = -args.velocityRatio

    update: (velocity) ->
      @setPosition util.adjustScreenPosition
        position: @getPosition().add(velocity.multiply(@velocityRatio))
        width: config.width * config.backgroundRatio
        height: config.height * config.backgroundRatio

    getPosition: ->
      new Vector @kineticStar.attrs.x, @kineticStar.attrs.y

    setPosition: (vec) ->
      @kineticStar.attrs.x = vec.x
      @kineticStar.attrs.y = vec.y

  layer = new Kinetic.Layer()

  init= ->

    ###
     create all the stars inside init to make sure all widths and heights
     were set by the dom update
    ###
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

    # add all stars to layer to be rendered
    stars.forEach (star) =>
      layer.add star.kineticStar

    # subscribe to update events
    eventbus.updated.add ->
      stars.forEach (star) ->
        star.update ship.velocity()
      layer.draw()

  # define return object - revealing module pattern
  init: init
  layer: layer