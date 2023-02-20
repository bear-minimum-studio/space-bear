
extends Node2D

const MAX_LENGTH = 5
const GRAPPLING_THROWING_FORCE = 500
const GRAPPLING_THROWING_ADJUSTMENT = GRAPPLING_THROWING_FORCE / 2

@onready var spawn_if_out_of_this = $SpawnIfOutOfThis
@onready var throwing_reference = $ThrowingReference
@onready var joint_to_player = $JointToPlayer


var hook_fragment = preload("res://grappling-hook/HookFragment.tscn")

@onready var first_fragment = $HookFragment
@onready var fragments = [$HookFragment]
var _should_keep_spawning = true

func _on_spawn_if_out_of_this_body_exited(body):
	# TODO attention verifier que c'est bien un enfant de notre scene
	if !body.is_in_group("hook_fragment"):
		return
	
	if fragments.size() == MAX_LENGTH and _should_keep_spawning:
		_should_keep_spawning = false
		throwing_reference.node_b = fragments[fragments.size() - 1].get_path()
		return
	
	if fragments.size() > MAX_LENGTH:
		printerr("Grappling hook should not exceed max size!")
		return
	
	call_deferred("_spawn")

func _spawn():
	var new_fragment = hook_fragment.instantiate()
	new_fragment.neighbour_fragment = fragments[fragments.size() - 1].get_path()
	fragments.append(new_fragment)
	self.add_child(new_fragment)

func launch(thrower: CharacterBody2D, thrower_rotation: float):
	throwing_reference.node_a = thrower.get_path()
	joint_to_player.node_b = thrower.get_path()

	$HookFragment.apply_impulse(GRAPPLING_THROWING_FORCE * Vector2.from_angle(thrower_rotation) + thrower.get_real_velocity())


func _on_hook_fragment_body_entered(body):
	print("hit")
	_should_keep_spawning = false
