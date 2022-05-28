extends Node

var default_volume = -12

var song1 = preload("res://sounds/Fixaproblem.ogg")
var song2 = preload("res://sounds/Fixaproblem.ogg")
var playlist = [song1, song2]

func _ready():
	var a = AudioStreamPlayer.new()
	a.set_stream(playlist[randi() % 2])
	a.set_volume_db(-80)
	a.set_bus("Music")
	a.set_autoplay(true)
	a.set_name("BGM")
	a.connect("finished", self, "_on_finished")
	add_child(a)
	
	var t = Tween.new()
	t.set_name("Tween")
	add_child(t)
	
	fade_in()


func _on_finished():
	$BGM.set_stream(playlist[randi() % 2])
	$BGM.play()


func fade_in():
	var tween = get_node("Tween")
	tween.interpolate_property($BGM, "volume_db",
			-80, default_volume, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func fade_out():
	var tween = get_node("Tween")
	tween.interpolate_property($BGM, "volume_db",
			default_volume, -80, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
