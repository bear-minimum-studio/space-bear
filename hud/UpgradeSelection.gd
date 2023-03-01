extends Control

func _ready():
	_update_ui()

func _input(event):
	if event.is_action_pressed("cycle_selection"):
		ShipCatalog.catalog.select_next_ship()
		_update_ui()

func _update_ui():
	$Label.text = ShipCatalog.catalog.get_current_ship_name()
