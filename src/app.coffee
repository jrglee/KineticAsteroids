define ["jquery", "config", "asteroids"], ($, config, asteroids) ->

  config.container = "container"
  config.width = window.innerWidth
  config.height = window.innerHeight

  $(document).ready ->
    console.log "document ready"

    asteroids.start()