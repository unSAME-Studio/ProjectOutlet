extends Node


func _ready():
	Global.main = self
	
	$"CanvasLayer/Control/UI/VBoxContainer/Level".set_text("Level %d" % Global.current_level)
	
	if Global.current_level_data.has("hint"):
		$CanvasLayer/Control/Hint.show()
		$CanvasLayer/Control/Hint/PanelContainer/MarginContainer/RichTextLabel.set_bbcode(Global.current_level_data["hint"])


func game_finished():
	$"CanvasLayer/Control/OverScreen".show()
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	for p in Global.console.attached_plugs:
		p.set_modulate(ColorManager.color.second)
		p.cable.set_modulate(ColorManager.color.second)
		p.get_node("AnimationPlayer").play("complete")
		
		$xylo.play()
		$xylo.set_pitch_scale($xylo.get_pitch_scale() + 0.05)
		
		yield(get_tree().create_timer(0.2), "timeout")
	
	yield(get_tree().create_timer(0.7), "timeout")
	$"CanvasLayer/Control/OverScreen/PanelContainer".show()
