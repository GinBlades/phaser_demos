root = exports ? this
window.onload = ->
  game = new Phaser.Game(640, 400, Phaser.AUTO, "game")
  game.state.add("Game", root.PhaserGame, true)
