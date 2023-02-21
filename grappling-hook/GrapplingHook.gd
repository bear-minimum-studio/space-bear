extends Area2D

@export_range(0,400) var max_length: int = 300
@export var hook_missile_initial_speed: float = 1000.0

const DISTANCE_TO_PLAYER = 40

# TODO this const should come from the HookFragment itself since it depends on its size
const DISTANCE_BETWEEN_FRAGMENTS = 15

@onready var player_pin_joint = $PlayerPinJoint

var hook_fragment = preload("res://grappling-hook/HookFragment.tscn")

var fragments = []
var player: Node2D
var hook_missile_velocity = Vector2.ZERO

enum SpawningState {
	SPAWNED,
	SPAWNING,
	BEFORE_SPAWN
}
var _spawning_state = SpawningState.BEFORE_SPAWN


func _spawn_grappling_fragments(grappled_body: RigidBody2D):
	# This function will be executed only once: upon spawning
	if _spawning_state != SpawningState.BEFORE_SPAWN:
		return

	_spawning_state = SpawningState.SPAWNING

	# Create all fragments
	for i in range(_get_number_of_fragments()):
		var new_hook: Node2D = hook_fragment.instantiate()

		if fragments.size() > 0:
			new_hook.transform.origin.x = fragments[-1].transform.origin.x + DISTANCE_BETWEEN_FRAGMENTS
		else:
			var offset = _get_distance() - DISTANCE_TO_PLAYER
			player_pin_joint.transform.origin.x -= offset
			new_hook.transform.origin.x -= offset

		self.add_child(new_hook)

		if fragments.size() == 0:
			player_pin_joint.node_b = new_hook.get_path()

		fragments.append(new_hook)

	# Attach each fragment to the next one
	for i in range(_get_number_of_fragments()-1):
		if i < fragments.size() - 1:
			var child = fragments[i]
			var next_child = fragments[i + 1]
			if next_child && next_child.is_inside_tree():
				child.neighbour_fragment = next_child.get_path()

	# Last fragment should be attached to the grappled body
	fragments[-1].neighbour_fragment = grappled_body.get_path()

func _disable_collisions_for_fragments_inside_grappled_body():
	for fragment in fragments:
		if fragment.get_contact_count() > 0:
			# Disable collisions by resetting the masks and layers. There might be a better way...
			fragment.collision_layer = 0
			fragment.collision_mask = 0

func _physics_process(delta):
	if _spawning_state == SpawningState.SPAWNED:
		return
		
	if _spawning_state == SpawningState.SPAWNING:
		# Waiting the first physics process to be able to disable problematic collisions
		_disable_collisions_for_fragments_inside_grappled_body()
		_spawning_state = SpawningState.SPAWNED
		return

	# Area2D movement
	self.translate(hook_missile_velocity * delta)
	self.look_at(player.global_transform.origin)
	# Little hack: we did all the calculations with the Area2D facing infinity, and not the player
	# Since we look at the player above, we rotate 180° to look back at the infinity
	self.rotate(PI)
	
	# If we miss the target, we simply stop the grappling hook and say that we're done
	if _get_distance() > max_length:
		_spawning_state = SpawningState.SPAWNED
		self.queue_free()

func _get_distance() -> float:
	return (self.global_transform.origin - player.global_transform.origin).length()

func _get_number_of_fragments() -> int:
	return floor(_get_distance() / float(DISTANCE_BETWEEN_FRAGMENTS))

func launch(thrower: Node2D, thower_rotation: float):
	player = thrower
	player_pin_joint.node_a = thrower.get_path()
	hook_missile_velocity = Vector2.from_angle(thower_rotation) * hook_missile_initial_speed


func _on_body_entered(body):
	if body is RigidBody2D:
		call_deferred("_spawn_grappling_fragments", body)
		# Maybe we should call these in _spawn_grappling_fragments
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
