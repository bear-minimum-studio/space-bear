@tool
extends VBoxContainer

enum Type {
	MOTHERSHIP,
	FLEET,
}
@export var type = Type.FLEET:
	set(new_type):
		type = new_type
		_update_sprite()

@export_range(0.5, 10.0, 0.5) var display_duration = 2.0

@onready var sprite = $Sprite
@onready var is_attacked_label = $IsAttackedContainer/IsAttacked

const sprites_mapping = {
	Type.MOTHERSHIP: preload("res://hud/FleetAttackIndicator/mothership_fleet_part.png"),
	Type.FLEET: preload("res://hud/FleetAttackIndicator/fleet_part.png"),
}

func _ready():
	_update_sprite()
	_hide_is_attacked()

func _update_sprite():
	if sprite == null:
		return

	sprite.texture = sprites_mapping[type]

func _hide_is_attacked():
	is_attacked_label.modulate.a = 0.0

var timer
func set_is_attacked():
	is_attacked_label.modulate.a = 1.0
	
	if timer == null:
		timer = get_tree().create_timer(display_duration)
	else:
		timer.time_left = display_duration

	await timer.timeout
	timer = null
	_hide_is_attacked()
