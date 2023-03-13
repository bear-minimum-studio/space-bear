extends Control

@onready var wheel_displayer = $WheelDisplayer

## set by Player/Selection_Zone
var selected_ship

## set by Game/SelectionWheel
var upgrade_candidate: ShipCatalogResourceElement:
	set(value):
		upgrade_candidate = value
		_upgrade(selected_ship)

func _ready():
	Events.selected_ship_changed.connect(_on_selected_ship_changed)
	wheel_displayer.upgrade_selected.connect(_on_upgrade_selected)

func _upgrade(ship):
	if upgrade_candidate == null:
		return
	if selected_ship == null:
		return
	
	var price = upgrade_candidate.price
	if FlockResources.get_resources() < price:
		return
	FlockResources.spend_resource(price)
	
	if ship.has_method("upgrade"):
		ship.upgrade(upgrade_candidate)

func _on_upgrade_selected(upgrade_index):
	upgrade_candidate = ShipCatalog.catalog.ships[upgrade_index]

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
