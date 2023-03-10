extends Node2D

@onready var world = $World
@onready var civilians_left = $CanvasLayer/MarginContainer/CiviliansLeft
@onready var game_over = $CanvasLayer/GameOver
@onready var level_end = $CanvasLayer/LevelEnd
@onready var sector_number = $CanvasLayer/MarginContainer/SectorNumber
@onready var level_change = $CanvasLayer/LevelChange

const worlds = [
	preload("res://World.tscn"), # first line doesn't matter yet
	preload("res://World2.tscn")
]

var current_world = 0

const BETWEEN_SECTORS_DURATION = 3

func _ready():
	Events.dead_ship.connect(_on_dead_civilian)
	Events.game_over.connect(_on_game_over)
	Events.restart.connect(_on_restart)
	_update_text(_count_civilians())
	
	Events.convoy_reached_wormhole.connect(_on_convoy_reached_wormhole)
	Events.player_reached_wormhole.connect(_on_player_reached_wormhole)

func _on_convoy_reached_wormhole():
	call_deferred("_level_change")
	print('level ended')

func _on_player_reached_wormhole():
	print('you reached the level end')

func _level_change():
	current_world += 1
	sector_number.set_sector(current_world + 1)
	
	if current_world == worlds.size():
		_show_end()
		return
	self.process_mode = Node.PROCESS_MODE_DISABLED

	# Create a new world
	var new_world_scene = worlds[current_world]
	var new_world = new_world_scene.instantiate()
	
	# Get the new mothership position to compute the offset with ours
	# then move every ship in the fleet back by the offset, so that
	# we start over at the proper position
	var current_flock = world.find_child("Flock")
	var current_mothership = current_flock.find_child("MotherShip")
	var new_empty_flock = new_world.find_child("Flock")
	var new_mothership = new_empty_flock.find_child("MotherShip")
	var offset = current_mothership.global_position - new_mothership.global_position
	for child in current_flock.get_children():
		child.translate(-offset)
	
	# Remove the new empty flock
	# then move the current flock to the new world to replace it
	new_world.remove_child(new_empty_flock)
	
	# Delete the old world, add the new one after seeing the between-sectors screen
	world.remove_child(current_flock)
	world.free()
	new_world.add_child(current_flock)
	self.add_child(new_world)

	level_change.visible = true
	await get_tree().create_timer(BETWEEN_SECTORS_DURATION).timeout
	level_change.visible = false

	self.process_mode = Node.PROCESS_MODE_INHERIT

func _input(event):
	if InputMode.is_controller():
		if event is InputEventMouseMotion or event is InputEventKey:
			InputMode.use_mouse()
	if InputMode.is_mouse():
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			InputMode.use_controller()

func _on_dead_civilian(dead_ship: Node2D):
	if dead_ship is Player:
		Events.game_over.emit()
	
	if dead_ship is MotherShip:
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

func _show_end():
	get_tree().paused = true
	level_end.visible = true

func _on_restart():
	get_tree().paused = false
	FlockResources.reset()
	get_tree().reload_current_scene()
