extends Node2D

# TODO: Maybe these should all be global helpers
# The functions don't use the tree and need to be plugged manually anyway

func animate_hurt(sprite: Node2D):
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)	

func animate_hurt_opacity(sprite: Node2D):
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.5, 0.1)
	tween.tween_property(sprite, "modulate:a", 1, 0.1)
