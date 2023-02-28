extends Sprite2D
@onready var gpu_particles_2d = $GPUParticles2D

func _ready():
	gpu_particles_2d.emitting = true
	
	# Free the explosion a few seconds after it's mounted
	# hardcoded and arbitrary value because there is no signal
	# coming from particles emitter to indicate the end
	await get_tree().create_timer(5).timeout
	self.queue_free()
