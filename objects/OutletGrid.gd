extends Node2D


export (PackedScene) var outlet
export (PackedScene) var plug

const GRID_SIZE = 200


func _ready():
	Global.grid = self
	
	# check if using the new format
	if Global.current_level_data.has("grid"):
		var grid = Global.current_level_data["grid"]
		for r in range(grid.size()):
			for c in range(grid[r].size()):
				
				# check if slot is true
				if grid[r][c] != 0:
				
					#print("Current at %d x %d" % [c, r])
					
					# generate the grid
					var o = outlet.instance()
					
					# set rotation from data
					var direction = 0
					if Global.current_level_data.has("rot"):
						direction = Global.current_level_data["rot"][r][c]
						
					o.initialize(Vector2(c, r), grid[r][c] - 1, direction)
					
					add_child(o)
					
					o.set_position(Vector2(c - (float(grid[r].size()) / 2.0), r - (float(grid.size()) / 2.0)) * GRID_SIZE + Vector2(GRID_SIZE / 2, GRID_SIZE / 2))
					
					o.set_modulate(ColorManager.color.main_dark)
					
					yield(get_tree().create_timer(0.1), "timeout")
	
	else:
		for i in Global.current_level_data["outlets"]:
			var o = outlet.instance()
			o.initialize(Vector2(i[0], i[1]), i[2], i[3])
			
			add_child(o)
			
			#o.set_position(Vector2(c - (float(grid[r].size()) / 2.0), r - (float(grid.size()) / 2.0)) * GRID_SIZE + Vector2(GRID_SIZE / 2, GRID_SIZE / 2))
			o.set_position(Vector2(i[0] - (float(Global.current_level_data["size"][0]) / 2.0), i[1] - (float(Global.current_level_data["size"][1]) / 2.0)) * GRID_SIZE + Vector2(GRID_SIZE / 2, GRID_SIZE / 2))
			#o.set_position(Vector2(i[0], i[1]) * GRID_SIZE + Vector2(GRID_SIZE, GRID_SIZE) / 2)
			
			o.set_modulate(ColorManager.color.main_dark)
			
			yield(get_tree().create_timer(0.1), "timeout")
		
	
	yield(get_tree().create_timer(0.3), "timeout")
	
	# spawn all the plugs
	var plugs_count = Global.current_level_data["plugs"].size()
	for i in range(plugs_count):
		var p = plug.instance()
		var info = Global.current_level_data["plugs"][i]
		
		p.size = Vector2(info[0], info[1])
		p.head_position = Vector2(info[2], info[3])
		
		# set outlet type from data
		if info.size() >= 5:
			p.outlet_type = info[4]
		
		# if additional outlet exist TEMP IMPLEMENT
		if info.size() >= 6:
			for add in info[5]:
				p.additional_outlets.append(add)
		
		# evenly spreading each plug along the bottom
		p.original_point = Vector2(get_viewport_rect().size.x / 2 / plugs_count * i - get_viewport_rect().size.x / 4, get_viewport_rect().size.y / 2 - p.size.y * GRID_SIZE / 2)
		
		get_parent().add_child(p)
		p.set_global_position(Vector2(0, get_viewport_rect().size.y / 2))
		
		yield(get_tree().create_timer(0.1), "timeout")
	
