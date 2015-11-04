game = new Phaser.Game(640, 480, Phaser.CANVAS, "game")

class PhaserGame
  constructor: (game) ->
    @map = null
    @layer = null
    @car = null
    @safeTile = 1
    @gridSize = 32
    @speed = 150
    @threshold = 3
    @turnSpeed = 150
    @marker = new Phaser.Point()
    @turnPoint = new Phaser.Point()

    @directions = [ null, null, null, null, null ]
    @opposites = [ Phaser.NONE, Phaser.RIGHT, Phaser.LEFT, Phaser.DOWN, Phaser.UP ]

    @current = Phaser.UP
    @turning = Phaser.NONE

  init: ->
    @physics.startSystem(Phaser.Physics.ARCADE)

  preload: ->
    @load.baseURL = "http://files.phaser.io.s3.amazonaws.com/codingtips/issue005/"
    @load.crossOrigin = "anonymous"

    @load.tilemap("map", "assets/maze.json", null, Phaser.Tilemap.TILED_JSON)
    @load.image("tiles", "assets/tiles.png")
    @load.image("car", "assets/car.png")

  create: ->
    @map = @add.tilemap("map")
    @map.addTilesetImage("tiles", "tiles")
    @layer = @map.createLayer("Tile Layer 1")
    @map.setCollision(20, true, @layer)

    @car = @add.sprite(48, 48, "car")
    @car.anchor.set(0.5)

    @physics.arcade.enable(@car)
    @cursors = @input.keyboard.createCursorKeys()

    @move(Phaser.DOWN)

  checkKeys: ->
    if @cursors.left.isDown && @current != Phaser.LEFT
      @checkDirection(Phaser.LEFT)
    else if @cursors.right.isDown && @current != Phaser.RIGHT
      @checkDirection(Phaser.RIGHT)
    else if @cursors.up.isDown && @current != Phaser.UP
      @checkDirection(Phaser.UP)
    else if @cursors.down.isDown && @current != Phaser.DOWN
      @checkDirection(Phaser.DOWN)
    else
      @turning = Phaser.NONE

  checkDirection: (turnTo) ->
    if @turning == turnTo || @directions[turnTo] == null || @directions[turnTo].index != @safeTile
      return

    if @current == @opposites[turnTo]
      @move(turnTo)

    else
      @turning = turnTo
      @turnPoint.x = (@marker.x * @gridSize) + (@gridSize / 2)
      @turnPoint.y = (@marker.y * @gridSize) + (@gridSize / 2)

  turn: ->
    cx = Math.floor(@car.x)
    cy = Math.floor(@car.y)

    if !@math.fuzzyEqual(cx, @turnPoint.x, @threshold) || !@math.fuzzyEqual(cy, @turnPoint.y, @turnPoint.y, @threshold)
      return false

    @car.x = @turnPoint.x
    @car.y = @turnPoint.y

    @car.body.reset(@turnPoint.x, @turnPoint.y)
    @move(@turning)
    @turning = Phaser.NONE

    return true

  move: (direction) ->
    speed = @speed
    
    if direction == Phaser.LEFT || direction == Phaser.UP
      speed = -speed

    if direction == Phaser.LEFT || direction == Phaser.RIGHT
      @car.body.velocity.x = speed
    else
      @car.body.velocity.y = speed

    @add.tween(@car).to( { angle: @getAngle(direction) }, @turnSpeed, "Linear", true)
    @current = direction

  getAngle: (to) ->
    if @current == @opposites[to]
      return "180"

    if (@current == Phaser.UP && to == Phaser.LEFT) || (@current == Phaser.DOWN && to == Phaser.RIGHT) || (@current == Phaser.LEFT && to == Phaser.DOWN) || (@current == Phaser.RIGHT && to == Phaser.UP)
      return "-90"

    return "90"

  update: ->
    @physics.arcade.collide(@car, @layer)
    @marker.x = @math.snapToFloor(Math.floor(@car.x), @gridSize) / @gridSize
    @marker.y = @math.snapToFloor(Math.floor(@car.y), @gridSize) / @gridSize

    @directions[1] = @map.getTileLeft(@layer.index, @marker.x, @marker.y)
    @directions[2] = @map.getTileRight(@layer.index, @marker.x, @marker.y)
    @directions[3] = @map.getTileAbove(@layer.index, @marker.x, @marker.y)
    @directions[4] = @map.getTileBelow(@layer.index, @marker.x, @marker.y)

    @checkKeys()

    if @turning != Phaser.NONE
      @turn()

  render: ->
    for t in [1...5]
      if @directions[t] == null
        continue

      color = "rgba(0, 255, 0, 0.3)"

      if @directions[t].index != @safeTile
        color = "rgba(255, 0, 0, 0.3)"

      if t == @current
        color = "rgba(255, 255, 255, 0.3)"

      @game.debug.geom(new Phaser.Rectangle(@directions[t].worldX, @directions[t].worldY, 32, 32), color, true)

    @game.debug.geom(@turnPoint, "#ffff00")

game.state.add("Game", PhaserGame, true)
