define ["signals"], (signals) ->
  updated: new signals.Signal()
  accelerated: new signals.Signal()
  reversed: new signals.Signal()
  turned: new signals.Signal()
  shot: new signals.Signal()