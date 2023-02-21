extends Area2D

const DISTANCE_BETWEEN_FRAGMENTS = 20

@export_range(0,400) var max_length: int = 300
@export var grapple_speed: float = 10.0

var hook_fragment = preload("res://grappling-hook/HookFragment.tscn")

@onready var player_pin_joint = $PlayerPinJoint
var fragments = []
var player

var velocity = Vector2.ZERO

var _has_been_spawned = false

func _spawn_grappling_fragments():
	if _has_been_spawned:
		return
	
	_has_been_spawned = true
	
	# TODO longueur du segment
	for i in range(_get_number_of_fragments()):
		var new_hook: Node2D = hook_fragment.instantiate()

		if fragments.size() > 0:
			new_hook.transform.origin.x = fragments[-1].transform.origin.x + DISTANCE_BETWEEN_FRAGMENTS
		else:
			var offset = _get_distance() - 20
			player_pin_joint.transform.origin.x -= offset
			new_hook.transform.origin.x -= offset

		self.add_child(new_hook)

		if fragments.size() == 0:
			player_pin_joint.node_b = new_hook.get_path()

		fragments.append(new_hook)

	# TODO longueur du segment
	for i in range(_get_number_of_fragments()):
		if i < fragments.size() - 1:
			var child = fragments[i]
			var next_child = fragments[i + 1]
			if next_child && next_child.is_inside_tree():
				child.neighbour_fragment = next_child.get_path()

func _physics_process(delta):
	if _has_been_spawned:
		return

	self.translate(velocity * delta)
	self.look_at(player.global_transform.origin)
	self.rotate(PI)
	
	if _get_distance() > max_length:
		_spawn_grappling_fragments()

func _get_distance() -> float:
	return (self.global_transform.origin - player.global_transform.origin).length()

func _get_number_of_fragments() -> int:
	return ceil(_get_distance() / float(DISTANCE_BETWEEN_FRAGMENTS))

func launch(thrower: Node2D, rotation: float, offset_velocity: Vector2):
	player = thrower
	player_pin_joint.node_a = thrower.get_path()
	velocity =  Vector2.from_angle(rotation) * grapple_speed


func _on_body_entered(_body):
	call_deferred("_spawn_grappling_fragments")
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
