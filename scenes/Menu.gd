extends Node


var button = preload("res://ui/LevelButton.tscn")
var plug = preload("res://objects/Plug.tscn")


func _ready():
	Global.main = self
	
	# show quit button only on PC build
	if OS.get_name() in ["Windows", "OSX", "X11"]:
		$CanvasLayer/Control/Options/VBoxContainer/Quit.show()
	
	# set offset for panel containers
	$CanvasLayer/Control/Levels/PanelContainer.set_custom_minimum_size(Vector2(min($Node2D.get_viewport_rect().size.x - 50, 1658), 1571))
	$CanvasLayer/Control/Levels/PanelContainer.set_size(Vector2(min($Node2D.get_viewport_rect().size.x - 50, 1658), 1571))
	$CanvasLayer/Control/Levels/PanelContainer.set_pivot_offset($CanvasLayer/Control/Levels/PanelContainer.get_size() / 2)
	
	# adjust grid columns
	if $Node2D.get_viewport_rect().size.x >= 1658:
		$CanvasLayer/Control/Levels/PanelContainer/MarginContainer/VBoxContainer/TabContainer/Levels/VBoxContainer/MarginContainer/ScrollContainer/GridContainer.set_columns(3)
	
	# generate levels
	for i in Global.level.keys():
		var b = button.instance()
		b.level = int(i)
		
		$CanvasLayer/Control/Levels/PanelContainer/MarginContainer/VBoxContainer/TabContainer/Levels/VBoxContainer/MarginContainer/ScrollContainer/GridContainer.add_child(b)
	
	# spawn the interactives
	$Node2D/Outlet.set_modulate(ColorManager.color.main_dark)
	var p = plug.instance()
	
	p.size = Vector2(3, 1)
	p.head_position = Vector2(1, 0)
	p.original_point = Vector2(0, 500)
	p.set_name("Plug")
	$Node2D.add_child(p)
	
	# change icon color
	$Node2D/GameTitle.set_modulate(ColorManager.color.main_dark)
	$Node2D/GameTitle2.set_modulate(ColorManager.color.main_dark)
	$Node2D/Outlet.get_node("BG").set_self_modulate(Color.white)
	
	# change blur shader color
	$"CanvasLayer/Control/Levels/PanelContainer".get_material().set_shader_param("color_main", ColorManager.color.background)
	
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


func _on_Settings_toggled(button_pressed):
	if button_pressed:
		$CanvasLayer/Control/Levels/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Settings.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	else:
		$CanvasLayer/Control/Levels/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Settings.set_h_size_flags(Control.SIZE_FILL)
	
	$CanvasLayer/Control/Levels/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Back.set_visible(not button_pressed)
	
	$CanvasLayer/Control/Levels/PanelContainer/MarginContainer/VBoxContainer/TabContainer.set_current_tab(button_pressed)


func _on_ColorSlider_value_changed(value):
	ColorManager.generate_color(float(value) / 255.0)
	ColorManager.apply_color()
