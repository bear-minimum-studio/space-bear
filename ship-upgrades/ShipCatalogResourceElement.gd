extends Resource
class_name ShipCatalogResourceElement

@export var price = 20
@export var display_name = "default name"
@export var scene: PackedScene
@export var ship_model: ShipCatalog.ShipModels
@export var upgrades: Array[ShipCatalogResourceElement] = []
