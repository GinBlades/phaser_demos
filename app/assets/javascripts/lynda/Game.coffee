root = exports ? this
root.BunnyDefender = root.BunnyDefender ? {}

class root.BunnyDefender.Game
  constructor: (@game) ->
    @totalBunnies
    @bunnyGroup
    @totalSpaceRocks
    @spaceRockGroup
    @burst
    @gameOver
    @countdown
    @overMessage
    @secondsElapsed
    @timer
    @music
    @ouch
    @boom
    @ding

  create: ->
    @gameOver = false
    @secondsElapsed = 0
    @timer = @time.create(false)
    @timer.loop(1000, @updateSeconds, @)
    @totalBunnies = 20
    @totalSpaceRocks = 13

    @music = @add.audio("game_audio")
    @music.play("", 0, 0.3, true)
    @ouch = @add.audio("hurt_audio")
    @boom = @add.audio("explosion_audio")
    @ding = @add.audio("select_audio")

    @buildWorld()

  updateSeconds: ->
    @secondsElapsed++

  buildWorld: ->
    @add.image(0, 0, "sky")
    @add.image(0, 800, "hill")
    @buildBunnies()
    # @buildSpaceRocks()
    # @buildEmitter()
    @countdown = @add.bitmapText(10, 10, "eightbitwonder", "Bunnies Left " + @totalBunnies, 20)
    @timer.start()

  buildBunnies: ->
    @bunnyGroup = @add.group()
    @bunnyGroup.enableBody = true
    for [0...@totalBunnies]
      b = @bunnyGroup.create(@rnd.integerInRange(-10, @world.width - 50),
        @rnd.integerInRange(@world.height - 180, @world.height - 60), "bunny", "Bunny0000")

      b.anchor.setTo(0.5, 0.5)
      b.body.moves = false
      b.animations.add("Rest", Phaser.ArrayUtils.numberArray(0,57))
      b.animations.add("Walk", Phaser.ArrayUtils.numberArray(67, 106))
      b.animations.play("Rest", 24, true)
      @assignBunnyMovement(b)
    return

  assignBunnyMovement: (b) ->
    bPosition = Math.floor(@rnd.realInRange(50, @world.width - 50))
    bDelay = @rnd.integerInRange(2000, 6000)
    if bPosition < b.x
      b.scale.x = 1
    else
      b.scale.x = -1

    t = @add.tween(b).to({x: bPosition}, 3500, Phaser.Easing.Quadratic.InOut, true, bDelay)
    t.onStart.add(@startBunny, @)
    t.onComplete.add(@stopBunny, @)

  startBunny: (b) ->
    b.animations.stop("Rest")
    b.animations.play("Walk", 24, true)

  stopBunny: (b) ->
    b.animations.stop("Walk")
    b.animations.play("Rest", 24, true)
    @assignBunnyMovement(b)
