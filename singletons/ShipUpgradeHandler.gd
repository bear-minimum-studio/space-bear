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

	if selected_ship != null:
		wheel_displayer.enabled = true
	else:
		wheel_displayer.enabled = false

	var elements = ShipCatalog.catalog.ships.map(func (element):
		return {
			"parameters": {
				"cost": element.price,
				"ship_name": element.display_name
			},
		}
	)
	wheel_displayer.elements = elements
