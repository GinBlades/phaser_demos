root = exports ? this
root.BunnyDefender = root.BunnyDefender ? {}

class root.BunnyDefender.Boot
  constructor: (@game) ->
   
  preload: ->
    @load.image("preloaderBar", "/lynda/images/loader_bar.png")
    @load.image("titleImage", "/lynda/images/TitleImage.png")
    return

  create: ->
    @input.maxPointers = 1
    @stage.disableVisibilityChange = false
    @stage.forceProtrait = true

    @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    @scale.minWidth = 270
    @scale.minHeight = 480
    @scale.pageAlignHorizontally = true
    @scale.pageAlignVertically = true

    @input.addPointer()
    @stage.backgroundColor = "#171642"

    @state.start("Preloader")
    return
