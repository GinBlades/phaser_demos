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
    @buildSpaceRocks()
    @buildEmitter()
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

  buildSpaceRocks: ->
    @spaceRockGroup = @add.group()
    for [0...@totalSpaceRocks]
      r = @spaceRockGroup.create(@rnd.integerInRange(0, @world.width), @rnd.realInRange(-1500, 0),
        "spaceRock", "SpaceRock0000")
      scale = @rnd.realInRange(0.3, 1.0)
      r.scale.x = scale
      r.scale.y = scale
      @physics.enable(r, Phaser.Physics.ARCADE)
      r.enableBody = true
      r.body.velocity.y = @rnd.integerInRange(200, 400)
      r.animations.add("Fall")
      r.animations.play("Fall", 24, true)
      r.checkWorldBounds = true
      r.events.onOutOfBounds.add(@resetRock, @)

  resetRock: (r) ->
    if r.y > @world.height
      @respawnRock(r)

  respawnRock: (r) ->
    if @gameOver == false
      r.reset(@rnd.integerInRange(0, @world.width), @rnd.realInRange(-1500, 0))
      r.body.velocity.y = @rnd.integerInRange(200, 400)

  buildEmitter: ->
    @burst = @add.emitter(0, 0, 80)
    @burst.minParticleScale = 0.3
    @burst.maxParticleScale = 1.2
    @burst.minParticleSpeed.setTo(-30, 30)
    @burst.maxParticleSpeed.setTo(30, -30)
    @burst.makeParticles("explosion")
    @input.onDown.add(@fireBurst, @)

  fireBurst: (pointer) ->
    if @gameOver == false
      @boom.play()
      @boom.volume = 0.2
      @burst.emitX = pointer.x
      @burst.emitY = pointer.y
      @burst.start(true, 2000, null, 20)

  burstCollision: (r, b) ->
    @respawnRock(r)

  bunnyCollision: (r, b) ->
    if b.exists
      @ouch.play()
      @respawnRock(r)
      @makeGhost(b)
      b.kill()
      @totalBunnies--
      @checkBunniesLeft()

  checkBunniesLeft: ->
    if @totalBunnies <= 0
      @gameOver = true
      @music.stop()
      @countdown.setText("Bunnies Left 0")
      @overMessage = @add.bitmapText(@world.centerX - 180, @world.centerY - 40, "eightbitwonder",
        "GAME OVER\n\n" + @secondsElapsed, 42)
      @overMessage.align = "center"
      @overMessage.inputEnabled = true
      @overMessage.events.onInputDown.addOnce(@quitGame, @)
    else
      @countdown.setText("Bunnies Left " + @totalBunnies)

  quitGame: (pointer) ->
    @ding.play()
    @state.start("StartMenu")

  friendlyFire: (b, e) ->
    if b.exists
      @ouch.play()
      @makeGhost(b)
      b.kill()
      @totalBunnies--
      @checkBunniesLeft()

  makeGhost: (b) ->
    bunnyGhost = @add.sprite(b.x - 20, b.y - 20, "ghost")
    bunnyGhost.anchor.setTo(0.5, 0.5)
    bunnyGhost.scale.x = b.scale.x
    @physics.enable(bunnyGhost, Phaser.Physics.ARCADE)
    bunnyGhost.enableBody = true
    bunnyGhost.checkWorldBounds = true
    bunnyGhost.body.velocity.y = -800

  update: ->
    @physics.arcade.overlap(@spaceRockGroup, @burst, @burstCollision, null, @)
    @physics.arcade.overlap(@spaceRockGroup, @bunnyGroup, @bunnyCollision, null, @)
    @physics.arcade.overlap(@bunnyGroup, @burst, @friendlyFire, null, @)
