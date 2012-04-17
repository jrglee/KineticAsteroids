define ["vector"], (Vector) ->

  adjustScreenPosition: (args) ->
    newPosition = args.position.clone()

    if newPosition.x < 0 then newPosition.x = args.width
    if newPosition.x > args.width then newPosition.x = 0
    if newPosition.y < 0 then newPosition.y = args.height
    if newPosition.y > args.height then newPosition.y = 0

    newPosition

  distance: (v1, v2) ->
    Math.sqrt(Math.pow(v2.x - v1.x, 2) + Math.pow(v2.y - v1.y))
