extends Node


func _ready():
	Global.main = self
	
	$"CanvasLayer/Control/Level".set_text("Level %d" % Global.current_level)
	
	if Global.console.level[Global.current_level].has("hint"):
		$CanvasLayer/Control/Hint.show()
		$CanvasLayer/Control/Hint/PanelContainer/MarginContainer/RichTextLabel.set_bbcode(Global.console.level[Global.current_level]["hint"])


func game_finished():
	$"CanvasLayer/Control/OverScreen".show()
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	for p in Global.console.attached_plugs:
		p.set_modulate(ColorManager.color.good)
		p.cable.set_modulate(ColorManager.color.good)
		p.get_node("AnimationPlayer").play("complete")
		
		yield(get_tree().create_timer(0.2), "timeout")
		
	$"CanvasLayer/Control/OverScreen/PanelContainer".show()
