extends Node2D

@onready var player = $Player
@onready var flock = $Flock

var grappling_hook_scene = preload("res://grappling-hook/GrapplingHook.tscn")
var current_hook : Node2D

func _ready():
	WorldReference.current_world = self
	
	Events.convoy_reached_wormhole.connect(_on_convoy_reached_wormhole)
	Events.player_reached_wormhole.connect(_on_player_reached_wormhole)

func _on_player_shoot_grappling_hook(global_player_position, global_player_rotation):
	# If shooting again while a grappling hook exists, delete the current one
	if current_hook != null:
		current_hook.queue_free()
		current_hook = null
		return

	var new_hook = grappling_hook_scene.instantiate()
	
	new_hook.global_position = global_player_position
	new_hook.global_rotation = global_player_rotation

	self.add_child(new_hook)

	current_hook = new_hook
	new_hook.launch(player, global_player_rotation)


func _on_convoy_reached_wormhole():
	print('level ended')

func _on_player_reached_wormhole():
	print('you reached the level end')

