extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

func _on_body_entered(body):
	if body.is_in_group('flock'):
		Events.convoy_reached_wormhole.emit()
		self.set_collision_mask_value(1, true) # Player can now reach wormhole too
	if body is Player:
		Events.player_reached_wormhole.emit()
