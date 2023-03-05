@tool
extends Node2D

enum BonusMalus {
	BONUS,
	MALUS
}
@export var earning_type = BonusMalus.BONUS:
	set(new_earning_type):
		earning_type = new_earning_type
		_update_amount()

@export var color: Color = Color("#6e98e4"):
	set(new_color):
		color = new_color
		_update_color()

@onready var label = $LabelContainer/Label
@onready var animation_player = $AnimationPlayer

var amount = 10

func init(init_amount: int):
	amount = init_amount

func _ready():
	_update_amount()
	if Engine.is_editor_hint():
		return

	animation_player.play("Floating")
	await animation_player.animation_finished
	self.queue_free()

func _update_color():
	if label == null:
		return

	label.remove_theme_color_override("font_color")
	label.add_theme_color_override("font_color", color)

func _update_amount():
	if label == null:
		return

	if earning_type == BonusMalus.BONUS:
		label.text = "+%s" % amount
	else:
		label.text = "-%s" % amount
