extends Control

@onready var label = $VBoxContainer/Label
@onready var resources_count = $VBoxContainer/HBoxContainer/ResourcesCount

func _ready():
	_update_ui()

func _input(event):
	if event.is_action_pressed("cycle_selection"):
		ShipCatalog.catalog.select_next_ship()
		_update_ui()

func _update_ui():
	label.text = ShipCatalog.catalog.get_current_ship_name()
	resources_count.amount = ShipCatalog.catalog.get_current_ship_price()
