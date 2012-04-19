define ["jquery", "config", "controls", "asteroids"], ($, config, controls, asteroids) ->

  config.container = "container"
  config.width = window.innerWidth
  config.height = window.innerHeight

  $(document).ready ->
    console.log "document ready"

    controls.init()

    asteroids.start()