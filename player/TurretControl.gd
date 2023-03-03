extends Node2D

signal nozzle_shoot_grappling_hook

const ROTATION_SPEED = 2.0

const HOOK_COOLDOWN = 1.0

var _reloading_hook = false
var current_hook: Node2D
var grappling_hook_scene = preload("res://grappling-hook/GrapplingHook.tscn")

@onready var p_2_nozzle = $P2Nozzle
@export var player: Node2D

func _physics_process(delta):
	var rotation_intensity = Input.get_axis("turret_left", "turret_right")
	self.rotation = self.rotation + rotation_intensity * ROTATION_SPEED * delta
	
	if (Input.is_action_pressed("grappling_hook")):
		_shoot_hook()

func _shoot_hook():
	if _reloading_hook:
		return

	_do_shoot_hook(p_2_nozzle.global_position, self.global_rotation)
	
	_reloading_hook = true
	await get_tree().create_timer(HOOK_COOLDOWN).timeout
	_reloading_hook = false

func _do_shoot_hook(global_player_position, global_player_rotation):
	# If shooting again while a grappling hook exists, delete the current one
	if current_hook != null:
		current_hook.queue_free()
		current_hook = null
		return

	var new_hook = grappling_hook_scene.instantiate()
	
	new_hook.global_position = global_player_position
	new_hook.global_rotation = global_player_rotation

	WorldReference.current_world.add_child(new_hook)

	current_hook = new_hook
	new_hook.launch(player, global_player_rotation)
