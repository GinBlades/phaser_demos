root = exports ? this

root.Weapon = {}

class root.Weapon.SingleBullet extends Phaser.Group
  constructor: (game) ->
    Phaser.Group.call(@, game, game.world, "Single Bullet", false, true, Phaser.Physics.ARCADE)

    @nextFire = 0
    @bulletSpeed = 600
    @fireRate = 100

    for [0...64]
      @add(new Bullet(game, "bullet5"), true)

  fire: (source) ->
    if @game.time.time < @nextFire
      return

    x = source.x + 10
    y = source.y + 10

    @getFirstExists(false).fire(x, y, 0, @bulletSpeed, 0, 0)
    @nextFire = @game.time.time + @fireRate

class root.Weapon.FrontAndBack extends Phaser.Group
  constructor: (game) ->
    Phaser.Group.call(@, game, game.world, "Front and Back", false, true, Phaser.Physics.ARCADE)
    @nextFire = 0
    @bulletSpeed = 600
    @fireRate = 100

    for [0...64]
      @add(new Bullet(game, "bullet5"), true)

  fire: (source) ->
    if @game.time.time < @nextFire
      return

    x = source.x + 10
    y = source.y + 10

    @getFirstExists(false).fire(x, y, 0, @bulletSpeed, 0, 0)
    @getFirstExists(false).fire(x, y, 180, @bulletSpeed, 0, 0)

    @nextFire = @game.time.time + @fireRate
