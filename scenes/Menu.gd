extends Node


var button = preload("res://ui/LevelButton.tscn")

func _ready():
	# generate levels
	for i in Global.level.keys():
		var b = button.instance()
		b.level = int(i)
		
		$Control/Levels/VBoxContainer/GridContainer.add_child(b)
		
	
	# show quit button only on PC build
	if OS.get_name() in ["Windows", "OSX"]:
		$Control/Options/VBoxContainer/Quit.show()


func _on_Play_pressed():
	$Control/Options.hide()
	$Control/Levels.show()


func _on_Editor_pressed():
	get_tree().change_scene("res://scenes/Editor.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	$Control/Options.show()
	$Control/Levels.hide()
