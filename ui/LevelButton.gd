extends MarginContainer

var level = 1
var level_size = Vector2.ZERO


func _ready():
	$Button/Label.set_text(String(level))
	
	# check mark
	if Global.level[level]["completed"]:
		$Button/Completed.show()
	
	if OS.get_name() in ["Windows", "OSX", "HTML5","X11"]:
		$Button.connect("mouse_entered", self, "_on_hover")
		$Button.connect("mouse_exited", self, "_on_mouse_exit")
	
	# generate mini map preview
	if Global.level[level].has("grid"):
		var grid = Global.level[level]["grid"]
		for r in range(grid.size()):
			for c in range(grid[r].size()):
				if grid[r][c] != 0:
					$Button/MarginContainer/Node2D/TileMap.set_cell(c, r, grid[r][c] - 1)
		
		level_size = Vector2(grid[0].size(), grid.size())
		$Button/MarginContainer/Node2D/TileMap.set_position(-level_size * 80 / 2)
	
	else:
		for i in Global.level[level]["outlets"]:
			$Button/MarginContainer/Node2D/TileMap.set_cell(i[0], i[1], i[2])
			
		level_size = Vector2(Global.level[level]["size"][0], Global.level[level]["size"][1])
		$Button/MarginContainer/Node2D/TileMap.set_position(-level_size * 80 / 2)


func _process(delta):
	var tilemap = $Button/MarginContainer/Node2D/TileMap
	if $Button.is_hovered():
		tilemap.set_position(lerp(tilemap.get_position(), $Button/MarginContainer/Node2D.to_local(get_global_mouse_position()) * -0.7 - level_size / 2 * 80, 10 * delta))
	else:
		tilemap.set_position(lerp(tilemap.get_position(), -level_size * 80 / 2, 10 * delta))


func _on_Button_pressed():
	Global.current_level = level
	SoundPlayer.play("Next")
	#get_tree().change_scene("res://scenes/Main.tscn")
	TransitionManager.play_out("res://scenes/Main.tscn")


func _on_hover():
	$AnimationPlayer.play("hover")
	
	$Button/Label.show()


func _on_mouse_exit():
	$AnimationPlayer.play_backwards("hover")
	
	$Button/Label.hide()
