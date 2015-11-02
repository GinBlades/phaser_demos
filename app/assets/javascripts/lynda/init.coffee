root = exports ? this

window.onload = ->
  game = new Phaser.Game(540, 960, Phaser.AUTO, "gameContainer")
  game.state.add("Boot", root.BunnyDefender.Boot)
  game.state.add("Preloader", root.BunnyDefender.Preloader)
  game.state.add("StartMenu", root.BunnyDefender.StartMenu)
  game.state.start("Boot")
