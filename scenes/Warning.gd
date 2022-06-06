extends Node


func _input(event):
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			$Timer.stop()
			TransitionManager.play_out("res://scenes/Menu.tscn")


func _on_Timer_timeout():
	TransitionManager.play_out("res://scenes/Menu.tscn")
