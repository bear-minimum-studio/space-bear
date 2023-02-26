extends Node2D

var radar_element_scene = preload("res://hud/radar/RadarElement.tscn")

func _physics_process(_delta):
	self.global_rotation = 0

	var enemies = get_tree().get_nodes_in_group("enemy")
	_sync_children(enemies.size())
	
	var index = 0
	for enemy in enemies:
		self.get_child(index).rotation = (enemy.global_position - self.global_position).angle()
		index += 1

# Makes sure that there are as many children scenes as enemies in the world
func _sync_children(nb_enemies: int):
	var nb_children = self.get_child_count()
	if nb_children == nb_enemies:
		return
	
	if nb_children > nb_enemies:
		var nb_children_to_free = nb_children - nb_enemies
		for i in range(nb_children_to_free):
			var child_to_free = get_child(i)
			child_to_free.queue_free()
	
	if nb_enemies > nb_children:
		var nb_children_to_create = nb_enemies - nb_children
		for i in range(nb_children_to_create):
			var new_child = radar_element_scene.instantiate()
			self.add_child(new_child)
