extends Sprite2D

signal animation_done

@export var hit_ship_color: Color = Color("#ffcf4d")
@export var hit_shield_color: Color = Color("#836dff")

@onready var animation_player = $AnimationPlayer

func _ready():
	self.visible = false

func adapt_style_then_play(hit_body: Node2D):
	# Adapt the style
	if hit_body is Shield:
		self.modulate = Color(hit_shield_color)
	else:
		self.modulate = Color(hit_ship_color)
		self.scale = 0.5 * Vector2.ONE
		
	# Play the animation
	self.visible = true
	animation_player.play("Explode")


func _on_animation_player_animation_finished(_anim_name):
	animation_done.emit()
