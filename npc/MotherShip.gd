extends CharacterBody2D

var health = 2
var SPEED = 30


func _physics_process(delta):
	velocity = Vector2(SPEED, 0).rotated(-PI/4.5); # up right
	move_and_slide()

func on_hit():
	if health > 0:
		health -= 1
		print("mothership health: ",health)
	if health <= 0:
		print("Mothership Ded")

func _on_hit_box_body_entered(body):
	if body.has_method("on_hit"):
		body.on_hit()
