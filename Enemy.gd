extends CharacterBody2D

var hp = 10

func on_hit():
	hp -= 1
	print("oh no I lost 1 hp")
	print(hp)
