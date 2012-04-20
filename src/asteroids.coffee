define ["config", "eventbus", "controls", "stage", "background", "stars", "ship"], (config, eventbus, controls, stage, background, stars, ship) ->
  initialized = false

  init = ->
    console.log "Initializing asteroids module"

    stage.init()

    stage.add [background, stars, ship].map (l) ->
      l.init() if l.init
      l.layer

    # initialize control module before starting the animation loop
    controls.init()

    stage.onFrame (frame) ->
      # apply user actions
      controls.dispatch()

      # update all objects in the script and render
      eventbus.updated.dispatch()

    # start game loop
    stage.start()

  start: ->
    if !initialized
      init()
      initialized = true

