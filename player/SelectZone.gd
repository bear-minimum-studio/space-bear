extends Area2D

@onready var selection_reference = $SelectionReference

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	var selectable_bodies = bodies.filter(func(body): return body.has_method("select"))
	var nearest = Helpers.find_nearest_node(selection_reference, selectable_bodies)
	
	if nearest == null:
		return
	
	for body in selectable_bodies:
		if !body.has_method("unselect"):
			printerr("Body has a 'select' method but no 'unselect' method... This should not happen!")
		body.unselect()

	nearest.select()

func _on_body_exited(body):
	if body.has_method("unselect"):
		body.unselect()
