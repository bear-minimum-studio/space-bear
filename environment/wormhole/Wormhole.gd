extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

var _enabled = false
func _ready():
	# Stupid hack because somehow when changing levels the wormhole
	# detects collisions again. This is probably fixable in a cleaner way but
	# this shitty hack will have no impact.
	await get_tree().create_timer(2, false).timeout
	_enabled = true

func _on_body_entered(body):
	if not _enabled:
		return

	if body is MotherShip:
		Events.convoy_reached_wormhole.emit()
		self.set_collision_mask_value(1, true) # Player can now reach wormhole too
	if body is Player:
		Events.player_reached_wormhole.emit()

func get_collision_size():
	return collision_shape_2d.shape.radius
