extends Area2D

const DISTANCE_BETWEEN_FRAGMENTS = 20

@export_range(0,400) var max_length: int = 300
@export var grapple_speed: float = 10.0

var hook_fragment = preload("res://grappling-hook/HookFragment.tscn")

@onready var player_pin_joint = $PlayerPinJoint
var fragments = []
var player
var grappled_body : RigidBody2D

var velocity = Vector2.ZERO

enum SpawningState {
	SPAWNED,
	SPAWNING,
	BEFORE_SPAWN
}

var _spawning_state = SpawningState.BEFORE_SPAWN

func _spawn_grappling_fragments():
	if !_spawning_state == SpawningState.BEFORE_SPAWN:
		return
	
	_spawning_state = SpawningState.SPAWNING
	
	for i in range(_get_number_of_fragments()):
		var new_hook: Node2D = hook_fragment.instantiate()

		if fragments.size() > 0:
			new_hook.transform.origin.x = fragments[-1].transform.origin.x + DISTANCE_BETWEEN_FRAGMENTS
		else:
			var offset = _get_distance() - 40
			player_pin_joint.transform.origin.x -= offset
			new_hook.transform.origin.x -= offset

		self.add_child(new_hook)

		if fragments.size() == 0:
			player_pin_joint.node_b = new_hook.get_path()

		fragments.append(new_hook)

	for i in range(_get_number_of_fragments()-1):
		if i < fragments.size() - 1:
			var child = fragments[i]
			var next_child = fragments[i + 1]
			if next_child && next_child.is_inside_tree():
				child.neighbour_fragment = next_child.get_path()
	fragments[-1].neighbour_fragment = self.grappled_body.get_path()

func _disable_fragments_in_grappled_body():
	if grappled_body: 
		for fragment in fragments:
			if fragment.get_contact_count() > 0:
				var toto: RigidBody2D = fragment
				toto.collision_layer = 0
				toto.collision_mask = 0
	else:
		printerr('Grappled body does not exist')

func _physics_process(delta):
	if _spawning_state == SpawningState.SPAWNED:
		return
		
	if _spawning_state == SpawningState.SPAWNING:
		_disable_fragments_in_grappled_body()
		_spawning_state = SpawningState.SPAWNED
		return

	self.translate(velocity * delta)
	self.look_at(player.global_transform.origin)
	self.rotate(PI)
	
	if _get_distance() > max_length:
		_spawning_state = SpawningState.SPAWNED

func _get_distance() -> float:
	return (self.global_transform.origin - player.global_transform.origin).length()

func _get_number_of_fragments() -> int:
	return floor(_get_distance() / float(DISTANCE_BETWEEN_FRAGMENTS))

func launch(thrower: Node2D, rotation: float, offset_velocity: Vector2):
	player = thrower
	player_pin_joint.node_a = thrower.get_path()
	velocity =  Vector2.from_angle(rotation) * grapple_speed


func _on_body_entered(body):
	if body is RigidBody2D:
		self.grappled_body = body
		call_deferred("_spawn_grappling_fragments")
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
