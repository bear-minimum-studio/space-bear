extends Control

@onready var resume_button = $CenterContainer/VBoxContainer/Resume

func _unhandled_input(event):
	if (event):
		if event.is_action_pressed("pause"):
			self.is_paused = !is_paused

var is_paused = false:
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused
	get:
		return is_paused

func _on_resume_pressed():
	self.is_paused = false

func _on_quit_pressed():
	get_tree().quit()

func _on_visibility_changed():
	if visible:
		resume_button.grab_focus()
