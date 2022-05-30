extends MarginContainer

var level = 1


func _ready():
	#$Button/Label.set_text(String(level))
	
	# generate mini map preview
	if Global.level[level].has("grid"):
		var grid = Global.level[level]["grid"]
		for r in range(grid.size()):
			for c in range(grid[r].size()):
				if grid[r][c] != 0:
					$Button/MarginContainer/TileMap.set_cell(c, r, grid[r][c] - 1)
		
		$Button/MarginContainer/TileMap.set_position(Vector2(230, 230) - Vector2(grid[0].size(), grid.size()) / 2 * 80)
	
	else:
		for i in Global.level[level]["outlets"]:
			$Button/MarginContainer/TileMap.set_cell(i[0], i[1], i[2])
			
		$Button/MarginContainer/TileMap.set_position(Vector2(230, 230) - Vector2(Global.level[level]["size"][0], Global.level[level]["size"][1]) / 2 * 80)


func _on_Button_pressed():
	Global.current_level = level
	#get_tree().change_scene("res://scenes/Main.tscn")
	TransitionManager.play_out("res://scenes/Main.tscn")
