@tool
extends Node2D

@export_range(1000,1000000,1000) var length: int = 100000:
	set(value): length = value 
	get: return length

@export_range(2.0,100.0,2.0) var width: float = 2.0:
	set(value): width = value
	get: return width

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _draw():
	if not visible:
		return
	if Engine.is_editor_hint():
		var mother_ship = $"../Flock/MotherShip"
		if mother_ship == null:
			printerr("There is no mother_ship.")
			return
		
		var start = mother_ship.global_position
		var stop = start + length * Vector2.from_angle(mother_ship.rotation)
		draw_line(start,stop,Color.ORANGE_RED,width,true)
