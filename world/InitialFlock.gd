extends Node2D

func initialize():
	for child in get_children():
		var child_global_position = child.global_position
		self.remove_child(child)
		self.get_parent().add_child(child)
		child.global_position = child_global_position
	self.queue_free()
