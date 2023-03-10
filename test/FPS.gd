extends Label

func _ready():
	if not OS.is_debug_build():
		self.visible = false

func _process(_delta: float) -> void:
	set_text("FPS %s" % Engine.get_frames_per_second())
