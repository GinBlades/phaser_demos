root = exports ? this
root.BunnyDefender = root.BunnyDefender ? {}

class root.BunnyDefender.StartMenu
  constructor: (@game) ->
    @startBG = null
    @startPrompt = null
    @ding = null

  create: ->
    @ding = @add.audio("select_audio")
    
    @startBG = @add.image(0, 0, "titleScreen")
    @startBG.inputEnabled = true
    @startBG.events.onInputDown.addOnce(@startGame, @)

    @startPrompt = @add.bitmapText(@world.centerX - 155, @world.centerY + 180, "eightbitwonder", "Touch to Start", 24)

  startGame: (pointer) ->
    @ding.play()
    @state.start("Game")
