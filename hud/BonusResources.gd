extends Node2D

@onready var label = $LabelContainer/Label
@onready var animation_player = $AnimationPlayer

var amount

func init(init_amount: int):
	amount = init_amount

func _ready():
	label.text = "+%s" % amount
	animation_player.play("Floating")
	await animation_player.animation_finished
	self.queue_free()
