define [
  "jquery"
  "cs!config"
  "cs!asteroids"
], ($, config, asteroids) ->
  config.container = "container"

  $(document).ready ->
    console.log "document ready"

    asteroids.start()