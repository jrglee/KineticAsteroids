define ["lib/kinetic"], (Kinetic) ->
  class Layer
    constructor: ->
      @pendingChanges = false

      @layer = new Kinetic.Layer()

    changed: ->
      @pendingChanges = true

    update: ->
      if @pendingChanges == true
        @layer.draw()
        @pendingChanges = false