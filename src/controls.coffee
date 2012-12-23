define [
  "jquery"
  "cs!config"
  "cs!eventbus"
], (
  $
  {turnAngle, acceleration}
  {turned, accelerated, shot}
) ->

  keyPressed = {}

  init= ->
    $(document).keydown (e) -> keyPressed[e.keyCode] = true
    $(document).keyup (e) -> delete keyPressed[e.keyCode]

  dispatchKeyActions = ->
    for keyCode of keyPressed
      switch Number(keyCode)
      # left arrow or a
        when 37, 65 then turnLeft()

      # right arrow or d
        when 39, 68 then turnRight()

      # up arrow or w
        when 38, 87 then accelerate()

      # down arrow or s
        when 40, 83 then reverse()

      # space bar
        when 32 then shoot()

  turnLeft = -> turned.dispatch -turnAngle
  turnRight = -> turned.dispatch turnAngle
  accelerate = -> accelerated.dispatch acceleration
  reverse = -> accelerated.dispatch -acceleration
  shoot = -> shot.dispatch()

  init: init
  dispatch: dispatchKeyActions