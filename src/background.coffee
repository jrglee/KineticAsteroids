define ["lib/kinetic", "config"], (Kinetic, config) ->
  initialized = false

  layer = new Kinetic.Layer()

  init = ->
    layer.add new Kinetic.Rect
      width: config.width
      height: config.height
      fill: "#001E4A"

  init: init
  layer: layer