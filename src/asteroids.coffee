define ["config", "eventbus", "stage", "background", "stars", "ship"], (config, eventbus, stage, background, stars, ship) ->
  initialized = false

  init = ->
    console.log "Initializing asteroids module"

    stage.init()

    stage.add [background, stars, ship].map (l) ->
      l.init() if l.init
      l.layer

    stage.onFrame (frame) ->
      eventbus.updated.dispatch()

    stage.start()

  start: ->
    if !initialized
      init()
      initialized = true

