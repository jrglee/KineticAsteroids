define [
  "jquery"
  "cs!config"
  "cs!asteroids"
], ($, config, asteroids) ->
  config.container = "container"

  $ -> asteroids.start()