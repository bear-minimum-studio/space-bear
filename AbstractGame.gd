extends Node2D

@onready var civilians_left = $CanvasLayer/MarginContainer/CiviliansLeft
@onready var game_over = $CanvasLayer/GameOver
@onready var level_end = $CanvasLayer/LevelEnd

func _ready():
	Events.dead_ship.connect(_on_dead_civilian)
	Events.game_over.connect(_on_game_over)
	Events.convoy_reached_wormhole.connect(_on_level_end)
	Events.restart.connect(_on_restart)
	_update_text(_count_civilians())

func _on_dead_civilian(dead_ship: Node2D):
	if dead_ship is Player:
		Events.game_over.emit()
	
	if dead_ship.is_in_group("flock") and dead_ship is AbstractCivilianShip:
		# The civilian is freed AFTER the signal is sent. So, it won't be counted as dead when we receive the signal.
		var nb_of_civilians_left = _count_civilians() - dead_ship.number_of_passengers
		_update_text(nb_of_civilians_left)
		if nb_of_civilians_left == 0:
			Events.game_over.emit()

func _count_civilians():
	var number_of_civilians = 0
	for ship in get_tree().get_nodes_in_group("flock"):
		if ship is AbstractCivilianShip:
			number_of_civilians += ship.number_of_passengers
	return number_of_civilians

func _update_text(nb_of_civilians_left: int):
	civilians_left.update_text(nb_of_civilians_left)

func _on_game_over():
	get_tree().paused = true
	game_over.visible = true

func _on_level_end():
	get_tree().paused = true
	level_end.visible = true

func _on_restart():
	get_tree().paused = false
	FlockResources.reset()
	get_tree().reload_current_scene()
