extends Node


@onready var fire_start = $FireStart
@onready var fire_sustain = $FireSustain

@onready var fx_bus_id = AudioServer.get_bus_index("Propulsion")
@onready var default_volume = AudioServer.get_bus_volume_db(fx_bus_id)

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
	fire_sustain.play()

func stop():
	if playing:
		playing = false
		_fade_out()

func _reset_volume():
	if tween_out:
		tween_out.stop()
	_set_volume_db(default_volume)

func _set_volume_db(volume_db):
	AudioServer.set_bus_volume_db(fx_bus_id,volume_db)

func _fade_out():
	tween_out = create_tween()
	tween_out.finished.connect(_on_TweenOut_finished)
	tween_out.tween_method(_set_volume_db, default_volume, -80, fade_out_duration)

func _on_TweenOut_finished():
	fire_start.stop()
	fire_sustain.stop()
