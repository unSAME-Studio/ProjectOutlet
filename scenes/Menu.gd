extends Node


func _on_Play_pressed():
	Global.current_level = int($Control/SpinBox.value)
	get_tree().change_scene("res://scenes/Main.tscn")
