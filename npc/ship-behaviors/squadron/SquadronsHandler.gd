extends Node2D

class_name SquadronsHandler

const SQUADRON_SCENE : PackedScene = preload("res://npc/ship-behaviors/squadron/Squadron.tscn")

var squadrons: Dictionary = {}
var squadron_id_seeds: Dictionary = {}

func _generate_squadron_id(id_seed: int, prefix: String = "") -> String:
	return '%s%d' % [prefix, id_seed]

func generate_new_squadron_id(prefix: String = "") -> String:
	var id_seed: int
	if squadron_id_seeds.has(prefix):
		id_seed = squadron_id_seeds[id_seed] + 1
	else:
		id_seed = 0
	var new_squadron_id = _generate_squadron_id(id_seed, prefix)
	while squadrons.has(new_squadron_id):
		id_seed += 1
		new_squadron_id = _generate_squadron_id(id_seed, prefix)
	squadron_id_seeds[prefix] = id_seed
	return new_squadron_id

func get_squadron(squadron_id: String) -> Squadron:
	if not squadrons.has(squadron_id):
		return null
	return squadrons[squadron_id]

func create_squadron(squadron_id: String) -> Squadron:
	if squadrons.has(squadron_id):
		printerr('There is already a squadron with id: %s' % squadron_id)
		return null
	var squadron = SQUADRON_SCENE.instantiate()
	squadron.id = squadron_id
	add_child(squadron)
	squadrons[squadron_id] = squadron
	return squadron

func get_or_create_squadron(squadron_id: String) -> Squadron:
	var squadron = get_squadron(squadron_id)
	if squadron != null:
		return squadron
	squadron = create_squadron(squadron_id)
	return squadron

func remove_squadron(squadron_id: String):
	if not squadrons.has(squadron_id):
		return
	squadrons.erase(squadron_id)
	
