extends Node


var button = preload("res://ui/LevelButton.tscn")
var plug = preload("res://objects/Plug.tscn")


func _ready():
	Global.main = self
	
	# generate levels
	for i in Global.level.keys():
		var b = button.instance()
		b.level = int(i)
		
		$"CanvasLayer/Control/Levels/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/GridContainer".add_child(b)
	
	# show quit button only on PC build
	if OS.get_name() in ["Windows", "OSX", "X11"]:
		$CanvasLayer/Control/Options/VBoxContainer/Quit.show()
	
	# spawn the interactives
	$Node2D/Outlet.set_modulate(ColorManager.color.main_dark)
	var p = plug.instance()
	
	p.size = Vector2(1, 2)
	p.head_position = Vector2(0, 1)
	p.original_point = Vector2(0, 500)
	p.set_name("Plug")
	$Node2D.add_child(p)
	
	# set offset for panel containers
	$CanvasLayer/Control/Levels/PanelContainer.set_pivot_offset($CanvasLayer/Control/Levels/PanelContainer.get_size() / 2)
	
	# change icon color
	$Node2D/GameTitle.set_modulate(ColorManager.color.main_dark)
	$Node2D/GameTitle2.set_modulate(ColorManager.color.main_dark)
	$Node2D/Outlet.get_node("BG").set_self_modulate(Color.white)
	
	$Node2D/Outlet.get_node("BG").hide()
	$Node2D/Outlet.get_node("BG2").hide()
	
	TransitionManager.play_in()


func game_finished():
	$CanvasLayer/Control/AnimationPlayer.play("title")
	
	yield(get_tree().create_timer(0.5), "timeout")
	_on_Play_pressed()


func _unhandled_input(event):
	if Input.is_action_just_pressed("editor"):
		_on_Editor_pressed()


func _on_Play_pressed():
	#$CanvasLayer/Control/Options.hide()
	$CanvasLayer/Control/Levels.show()
	$CanvasLayer/Control/AnimationPlayer.play("level")


func _on_Editor_pressed():
	#get_tree().change_scene("res://scenes/Editor.tscn")
	TransitionManager.play_out("res://scenes/Editor.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	SoundPlayer.play("Back")
	$CanvasLayer/Control/AnimationPlayer.play_backwards("level")
	yield($CanvasLayer/Control/AnimationPlayer, "animation_finished")
	
	$CanvasLayer/Control/Levels.hide()
	
	get_node("Node2D/Plug").unplug()
