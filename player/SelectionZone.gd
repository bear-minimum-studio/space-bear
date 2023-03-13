extends Area2D

@onready var selection_reference = $SelectionReference

var current_selection: Node2D = null:
	set(value):
		if current_selection == value:
			# Don't spam with new events if still seeing the same ship
			return
		current_selection = value
		Events.selected_ship_changed.emit(value)

func _physics_process(_delta):
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
	current_selection = nearest

func _on_body_exited(body):
	if body.has_method("unselect"):
		body.unselect()
		if body == current_selection:
			current_selection = null
