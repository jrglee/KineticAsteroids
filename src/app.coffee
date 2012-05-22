define ["jquery", "config", "asteroids"], ($, config, asteroids) ->

  config.container = "container"

  $(document).ready ->
    console.log "document ready"

    asteroids.start()