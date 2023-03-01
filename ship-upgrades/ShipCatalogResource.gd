extends Resource
class_name ShipCatalogResource

@export var ships: Array[ShipCatalogResourceElement] = []

var _current_selection = 0

func _get_current_selection():
	return ships[_current_selection]

func select_next_ship():
	_current_selection += 1 
	_current_selection = _current_selection % ships.size()

func get_current_ship_name():
	return _get_current_selection().display_name

func get_current_ship_scene():
	return _get_current_selection().scene

func get_current_ship_price():
	return _get_current_selection().price
