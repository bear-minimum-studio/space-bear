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

func _on_upgrade_selected(upgrade_index):
	var selected_upgrade = ShipCatalog.catalog.ships[upgrade_index]
	_upgrade_selected_ship(selected_upgrade)

func _on_selected_ship_changed(new_ship):
	selected_ship = new_ship
	
	if new_ship is MotherShip:
		wheel_displayer.disable()
		return

	var ship_catalog_elem
	if selected_ship != null:
		wheel_displayer.enable()
		ship_catalog_elem = ShipCatalog.find_ship_in_tree(new_ship)
	else:
		wheel_displayer.disable()

	var upgrades = ShipCatalog.catalog.ships if ship_catalog_elem == null else ship_catalog_elem.upgrades
	
	if upgrades == null or upgrades.size() == 0:
		wheel_displayer.disable()
		return

	var elements = upgrades.map(func (element):
		return {
			"parameters": {
				"cost": element.price,
				"ship_name": element.display_name
			},
			"is_selectable": element.price <= FlockResources.get_resources(),
		}
	)
	wheel_displayer.set_elements(elements)


func _on_wheel_displayer_opening_upgrades():
	Events.opening_ship_upgrades.emit(selected_ship)

func _on_wheel_displayer_closing_upgrades():
	Events.closing_ship_upgrades.emit()
