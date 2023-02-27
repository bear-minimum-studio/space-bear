@tool
extends Node2D

@export var shield_color: Color = Color("#0096ff2b") :
	set(new_color):
		shield_color = new_color
		queue_redraw()

@export var shield_outline: Color = Color("#0974ad") :
	set(new_color):
		shield_outline = new_color
		queue_redraw()

@export var shield_size: float = 100.0 :
	set(new_shield_size):
		shield_size = new_shield_size
		queue_redraw()

@export var outline_width: float = 2.0 :
	set(new_outline_width):
		outline_width = new_outline_width
		queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, shield_size, shield_color)
	draw_arc(Vector2.ZERO, shield_size, 0, 2 * PI, 50, shield_outline, outline_width, false)
