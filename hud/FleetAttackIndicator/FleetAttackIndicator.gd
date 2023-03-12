extends MarginContainer

@onready var fleet_attack_container = $Panel/MarginContainer/FleetAttackContainer

func _ready():
	Events.ship_hurt.connect(_on_ship_hurt)

func _on_ship_hurt(ship: Node2D):
	if !ship.is_in_group("flock"):
		return

	var fleet_proportion_from_mothership = WorldReference.current_world.get_global_position_to_fleet_proportion(ship)
	var fleet_proportion_starting_from_end = 1 - fleet_proportion_from_mothership
	_set_under_attack(fleet_proportion_starting_from_end)

func _set_under_attack(proportion: float):
	var nb_child = fleet_attack_container.get_child_count()
	var max_child_index = nb_child - 1

	var child_index_to_show = round(lerp(0.0, float(max_child_index), proportion))

	fleet_attack_container.get_child(child_index_to_show).set_is_attacked()
