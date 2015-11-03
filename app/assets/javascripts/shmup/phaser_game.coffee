root = exports ? this

class root.PhaserGame
  constructor: ->
    @background = null
    @foreground = null
    @player = null
    @cursors = null
    @speed = 300

    @weapons = []
    @currentWeapon = 0
    @weaponName = null

  init: ->
    @game.renderer.renderSession.roundPixels = true
    @physics.startSystem(Phaser.Physics.ARCADE)

  preload: ->
    @load.baseURL = "http://files.phaser.io.s3.amazonaws.com/codingtips/issue007/"
    @load.crossOrigin = "anonymous"
    @load.image("background", "assets/back.png")
    @load.image("foreground", "assets/fore.png")
    @load.image("player", "assets/ship.png")
    @load.bitmapFont("shmupfont", "assets/shmupfont.png", "assets/shmupfont.xml")

    for i in [1..11]
      @load.image("bullet" + i, "assets/bullet#{i}.png")

  create: ->
    @background = @add.tileSprite(0, 0, @game.width, @game.height, "background")
    @background.autoScroll(-40, 0)

    @weapons.push(new Weapon.SingleBullet(@game))
    @weapons.push(new Weapon.FrontAndBack(@game))

    @currentWeapon = 0

    for weapon in @weapons
      weapon.visible = false

    @player = @add.sprite(64, 200, "player")
    @physics.arcade.enable(@player)
    @player.body.collideWorldBounds = true
    @foreground = @add.tileSprite(0, 0, @game.width, @game.height, "foreground")
    @foreground.autoScroll(-60, 0)
    @weaponName = @add.bitmapText(8, 364, "shmupfont", "ENTER = Next Weapon", 24)

    @cursors = @input.keyboard.createCursorKeys()
    @input.keyboard.addKeyCapture([Phaser.Keyboard.SPACEBAR])
    changeKey = @input.keyboard.addKey(Phaser.Keyboard.ENTER)
    changeKey.onDown.add(@nextWeapon, @)
    return

  nextWeapon: ->
    if @currentWeapon > 9
      @weapons[@currentWeapon].reset()
    else
      @weapons[@currentWeapon].visible = false
      @weapons[@currentWeapon].callAll("reset", null, 0, 0)
      @weapons[@currentWeapon].setAll("exists", false)

    @currentWeapon++

    if @currentWeapon == @weapons.length
      @currentWeapon = 0

    @weapons[@currentWeapon].visible = true
    @weaponName.text = @weapons[@currentWeapon].name

  update: ->
    @player.body.velocity.set(0)

    if @cursors.left.isDown
      @player.body.velocity.x = -@speed
    else if @cursors.right.isDown
      @player.body.velocity.x = @speed
    
    if @cursors.up.isDown
      @player.body.velocity.y = -@speed
    else if @cursors.down.isDown
      @player.body.velocity.y = @speed

    if @input.keyboard.isDown(Phaser.Keyboard.SPACEBAR)
      @weapons[@currentWeapon].fire(@player)
