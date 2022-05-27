extends MarginContainer

var level = 1


func _ready():
	$Button.set_text(String(level))


func _on_Button_pressed():
	Global.current_level = level
	get_tree().change_scene("res://scenes/Main.tscn")
