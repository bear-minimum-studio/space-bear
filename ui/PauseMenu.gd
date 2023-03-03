extends Control

signal upgrade_01_signal
signal upgrade_02_signal
signal upgrade_03_signal

@onready var resume_button = $MainMenu/VBoxContainer/Resume
@onready var main_menu = $MainMenu
@onready var upgrade_menu = $UpgradeMenu

func _unhandled_input(event):
	if (event && event.is_action_pressed("pause")):
		if (self.is_paused):
				main_menu.visible = true
				upgrade_menu.visible = false
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

func _on_upgrade_pressed():
	main_menu.visible = false
	upgrade_menu.visible = true

func _on_back_pressed():
	main_menu.visible = true
	upgrade_menu.visible = false

func _on_upgrade_1_pressed():
	emit_signal("upgrade_01_signal")

func _on_upgrade_2_pressed():
	emit_signal("upgrade_02_signal")

func _on_upgrade_3_pressed():
	emit_signal("upgrade_03_signal")
