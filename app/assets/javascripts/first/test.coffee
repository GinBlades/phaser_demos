root = exports ? this

preload = ->
  1

create = ->
  1

update = ->
  1

game = new Phaser.Game 800, 600, Phaser.AUTO, "",
  preload: preload
  create: create
  update: update
