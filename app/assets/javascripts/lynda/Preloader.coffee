root = exports ? this
root.BunnyDefender = root.BunnyDefender ? {}

class root.BunnyDefender.Preloader
  constructor: (@game) ->
    @preloadBar = null
    @titleText = null
    @ready = false

  preload: ->
    @preloadBar = @add.sprite(@world.centerX, @world.centerY, "preloaderBar")
    @preloadBar.anchor.setTo(0.5, 0.5)
    @load.setPreloadSprite(@preloadBar)

    @titleText = @add.image(@world.centerX, @world.centerY - 220, "titleImage")
    @titleText.anchor.setTo(0.5, 0.5)
    @load.image("titleScreen", "/lynda/images/TitleBG.png")
    @load.bitmapFont("eightbitwonder", "/lynda/fonts/eightbitwonder.png", "/lynda/fonts/eightbitwonder.fnt")
    @load.atlasXML("bunny", "/lynda/images/spritesheets/bunny.png", "/lynda/images/spritesheets/bunny.xml")
    @load.atlasXML("spaceRock", "/lynda/images/spritesheets/SpaceRock.png", "/lynda/images/spritesheets/SpaceRock.xml")
    @load.image("explosion", "/lynda/images/explosion.png")
    @load.image("ghost", "/lynda/images/ghost.png")
    @load.audio("explosion_audio", "/lynda/audio/explosion.mp3")
    @load.audio("hurt_audio", "/lynda/audio/hurt.mp3")
    @load.audio("select_audio", "/lynda/audio/select.mp3")
    @load.audio("game_audio", "/lynda/audio/bgm.mp3")

  create: ->
    @preloadBar.cropEnabled = false

  update: ->
    if @cache.isSoundDecoded("game_audio") && @ready == false
      @ready = true
      @state.start("StartMenu")
