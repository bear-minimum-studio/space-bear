extends HBoxContainer

@export var amount = 10:
	set(new_amount):
		amount = new_amount
		_update_amount()

@onready var label = $Label

func _ready():
	_update_amount()

func _update_amount():
	label.text = "%s" % amount
