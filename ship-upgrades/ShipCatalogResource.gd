extends Resource
class_name ShipCatalogResource

@export var ships: Array[ShipCatalogResourceElement] = []

var current_selection = 0:
	set(value):
		current_selection = value
		selection_changed.emit()

signal selection_changed

func size():
	return ships.size()

func _get_current_selection():
	return ships[current_selection]

func select_next_ship():
	current_selection += 1 
	current_selection = current_selection % ships.size()

func get_current_ship_name():
	return _get_current_selection().display_name

func get_current_ship_scene():
	return _get_current_selection().scene

func get_current_ship_price():
	return _get_current_selection().price
