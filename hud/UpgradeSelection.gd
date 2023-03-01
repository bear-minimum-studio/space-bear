extends Control

func _ready():
	_update_ui()

func _input(event):
	if event.is_action_pressed("cycle_selection"):
		ShipTypes.select_next_ship()
		_update_ui()

func _update_ui():
	$Label.text = ShipTypes.get_current_ship_name()
