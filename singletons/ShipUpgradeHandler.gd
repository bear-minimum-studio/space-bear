extends Control

@onready var wheel_displayer = $WheelDisplayer

var selected_ship

func _ready():
	Events.selected_ship_changed.connect(_on_selected_ship_changed)
	wheel_displayer.upgrade_selected.connect(_on_upgrade_selected)

func _upgrade_selected_ship(selected_upgrade):
	if selected_upgrade == null:
		return
	if selected_ship == null:
		return
	
	var price = selected_upgrade.price
	if FlockResources.get_resources() < price:
		return
	FlockResources.spend_resource(price)
	
	if selected_ship.has_method("upgrade"):
		selected_ship.upgrade(selected_upgrade)

func _on_upgrade_selected(selected_upgrade_element):
	_upgrade_selected_ship(selected_upgrade_element.catalog_element)

func _on_selected_ship_changed(new_ship):
	print("ship changed")
	wheel_displayer.dismiss(true)
	selected_ship = new_ship
	
	if selected_ship == null or selected_ship.is_ship_upgradable == false:
		wheel_displayer.disable()
		return

	wheel_displayer.enable()
	var current_ship_in_catalog = ShipCatalog.find_ship_in_tree(new_ship)

	var available_upgrades = ShipCatalog.catalog.ships if current_ship_in_catalog == null else current_ship_in_catalog.upgrades
	
	if available_upgrades == null or available_upgrades.size() == 0:
		wheel_displayer.disable()
		return

	var elements = available_upgrades.map(func (upgrade):
		return {
			"parameters": {
				"cost": upgrade.price,
				"ship_name": upgrade.display_name
			},
			"is_selectable": upgrade.price <= FlockResources.get_resources(),
			"catalog_element": upgrade,
		}
	)
	wheel_displayer.set_elements(elements)


func _on_wheel_displayer_opening_upgrades():
	Events.opening_ship_upgrades.emit(selected_ship)

func _on_wheel_displayer_closing_upgrades():
	Events.closing_ship_upgrades.emit()
