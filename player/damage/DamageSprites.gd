extends Node2D

const DAMAGE_STEPS = [0.8, 0.5, 0.2]

func _ready():
	if DAMAGE_STEPS.size() != get_child_count():
		printerr("Something is wrong with DamageSprites: different amount of sprites and damage steps!")

func show_sprite_for_damage_level(damage: float):
	for damage_sprite in get_children():
		damage_sprite.visible = false

	if damage >= DAMAGE_STEPS[0]:
		return
	
	var index = 0
	for damage_step in DAMAGE_STEPS:
		if damage < damage_step:
			get_child(index).visible = true
			index += 1
		else:
			return
