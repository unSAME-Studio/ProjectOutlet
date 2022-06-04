extends Node


func _ready():
	load_game()


func save_game():
	# HTML5 Cookie bug fixes
	if not OS.is_userfs_persistent():
		return 
	
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	var save_dict = {}
	for i in Global.level.keys():
		save_dict[i] = Global.level[i]["completed"]
	
	save_game.store_var(save_dict)
	
	save_game.close()


func load_game():
	# HTML5 Cookie bug fixes
	if not OS.is_userfs_persistent():
		return 
	
	var save_game = File.new()
	
	# create a new save file then open
	if not save_game.file_exists("user://savegame.save"):
		save_game()
	
	save_game.open("user://savegame.save", File.READ)
	
	var save_dict = save_game.get_var()
	
	# Set values to global
	for key in save_dict.keys():
		Global.level[key]["completed"] = save_dict[key]

	save_game.close()
