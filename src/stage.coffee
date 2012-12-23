define [
  'kinetic'
  'cs!config'
], (Kinetic, config) ->
  kineticStage = null

  init = ->
    kineticStage = new Kinetic.Stage
      container: config.container
      width: config.width
      height: config.height

  addLayers = (layers) ->
    throw new Error("Stage is not initialized") if !kineticStage
    layers.forEach (layer) ->
      kineticStage.add layer

  setFrameFunction = (fn) ->
    kineticStage.onFrame fn

  start = ->
    throw new Error("Stage is not initialized") if !kineticStage
    kineticStage.start()

  init: init
  add: addLayers
  onFrame: setFrameFunction
  start: start
