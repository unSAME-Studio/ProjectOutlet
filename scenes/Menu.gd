extends Node


func _on_Play_pressed():
	Global.current_level = 1
	get_tree().change_scene("res://scenes/Main.tscn")
