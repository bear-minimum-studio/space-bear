extends Node


@onready var fire_start = $FireStart
@onready var default_volume = fire_start.volume_db

@export var fade_out_duration = 0.5

var tween_out
var playing = false


func play():
	if not playing:
		_play_start()

func _play_start():
	playing = true
	_reset_volume()
	fire_start.play()

func stop():
	if playing:
		playing = false
		_fade_out()

func _reset_volume():
	if tween_out:
		tween_out.stop()
	fire_start.volume_db = default_volume

func _fade_out():
	tween_out = create_tween()
	tween_out.finished.connect(_on_TweenOut_finished)
	tween_out.tween_property(fire_start, "volume_db", -80, fade_out_duration).from_current()

func _on_TweenOut_finished():
	fire_start.stop()
