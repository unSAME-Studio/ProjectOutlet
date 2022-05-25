extends Node


func _ready():
	Global.main = self
	
	$"CanvasLayer/Control/Level".set_text("Level %d" % Global.current_level)
	
	if Global.console.level[Global.current_level].has("hint"):
		$CanvasLayer/Control/Hint.show()
		$CanvasLayer/Control/Hint/PanelContainer/MarginContainer/RichTextLabel.set_bbcode(Global.console.level[Global.current_level]["hint"])


func game_finished():
	$"CanvasLayer/Control/OverScreen".show()
