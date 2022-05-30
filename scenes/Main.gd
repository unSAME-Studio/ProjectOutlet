extends Node


var anything_attached


func _ready():
	Global.main = self
	
	$"CanvasLayer/Control/UI/VBoxContainer/Level".set_text("Level %d" % Global.current_level)
	
	if Global.current_level_data.has("hint"):
		$CanvasLayer/Control/Hint.show()
		$CanvasLayer/Control/Hint/PanelContainer/MarginContainer/RichTextLabel.set_bbcode(Global.current_level_data["hint"])
		$CanvasLayer/Control/AnimationPlayer.play("hint")
		
	# set state of music btn
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")):
		$"CanvasLayer/Control/UI/VBoxContainer/MarginContainer2/SoundButton".set_pressed(true)
	
	
	TransitionManager.play_in()


func _process(delta):
	if Global.console.attached_plugs.size() > 0:
		$CanvasLayer/Control/UI/VBoxContainer/MarginContainer/RestartButton.set_disabled(false)
		$CanvasLayer/Control/UI/VBoxContainer/MarginContainer/RestartButton.set_modulate(Color("ffffff"))
	else:
		$CanvasLayer/Control/UI/VBoxContainer/MarginContainer/RestartButton.set_disabled(true)
		$CanvasLayer/Control/UI/VBoxContainer/MarginContainer/RestartButton.set_modulate(Color("50000000"))
		

func game_finished():
	$"CanvasLayer/Control/UI".hide()
	$CanvasLayer/Control/Hint.hide()
	$"CanvasLayer/Control/OverScreen".show()
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	for p in Global.console.attached_plugs:
		p.hovering = false
		p.set_modulate(ColorManager.color.second)
		p.cable.set_modulate(ColorManager.color.second)
		p.get_node("AnimationPlayer").play("complete")
		
		$xylo.play()
		$xylo.set_pitch_scale($xylo.get_pitch_scale() + 0.05)
		
		yield(get_tree().create_timer(0.2), "timeout")
	
	yield(get_tree().create_timer(0.4), "timeout")
	$CanvasLayer/Control/AnimationPlayer.play("complete")
	$"CanvasLayer/Control/OverScreen/PanelContainer".show()


func _on_RestartButton_pressed():
	if Global.console.attached_plugs.size() <= 0:
		return
	
	while Global.console.attached_plugs.size() > 0:
		Global.console.attached_plugs.keys().back().unplug()
	
	var btn = get_node("CanvasLayer/Control/UI/VBoxContainer/MarginContainer/RestartButton")
	btn.get_node("Tween").interpolate_property(btn, "rect_rotation",
			0, 360, 1,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	btn.get_node("Tween").start()


func _on_SoundButton_toggled(mute):
	if not mute:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)


func _on_HomeButton_pressed():
	#get_tree().change_scene("res://scenes/Menu.tscn")
	TransitionManager.play_out("res://scenes/Menu.tscn")


func _on_Next_pressed():
	Global.current_level += 1
	SoundPlayer.play("Next")
	
	if Global.level.has(Global.current_level):
		#get_tree().reload_current_scene()
		TransitionManager.play_out("res://scenes/Main.tscn")
	else:
		#get_tree().change_scene("res://scenes/Menu.tscn")
		TransitionManager.play_out("res://scenes/Menu.tscn")
		
