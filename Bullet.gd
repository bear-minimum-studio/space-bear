extends Sprite2D

const SPEED = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	translate(delta * self.rotation * SPEED)
	translate(Vector2(delta * SPEED * cos(self.rotation), delta * SPEED * sin(self.rotation)))
