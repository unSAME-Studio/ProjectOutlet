extends Node


var avaliable_plugs = {}
var attached_plugs = {}


func _ready():
	Global.console = self
	
	ColorManager.generate_color()
	ColorManager.apply_color()


func detect_complete():
	if avaliable_plugs.size() == 0:
		game_finished()


func game_finished():
	Global.level[Global.current_level]["completed"] = true
	SaveSystem.save_game()
	
	Global.main.game_finished()

