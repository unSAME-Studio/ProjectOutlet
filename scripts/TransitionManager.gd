extends Node


var transition = preload("res://ui/transition/Transition.tscn")


func play_in(scene = null):
	# Transition Mask
	var t = transition.instance()
	t.reversed = true
	add_child(t)
	
	if scene:
		yield(t, "blackout")
		get_tree().change_scene(scene)


func play_out(scene = null):
	# Transition Mask
	var t = transition.instance()
	add_child(t)
	
	if scene:
		yield(t, "blackout")
		get_tree().change_scene(scene)
