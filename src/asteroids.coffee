define [
  'kinetic'
  "cs!config"
  "cs!eventbus"
  "cs!controls"
  "cs!background"
  "cs!stars"
  "cs!ship"
], (Kinetic, config, eventbus, controls, background, stars, ship) ->
  initialized = false

  init = ->
    console.log "Initializing asteroids module"

    stage = new Kinetic.Stage
      container: config.container
      width: config.width
      height: config.height

    for l in [background, stars, ship]
      l.init?()
      stage.add l.layer

    # initialize control module before starting the animation loop
    controls.init()

    anim = new Kinetic.Animation (frame) ->
      # apply user actions
      controls.dispatch()

      # update all objects in the script and render
      eventbus.updated.dispatch()

    # start game loop
    anim.start()

  start: ->
    if !initialized
      init()
      initialized = true

