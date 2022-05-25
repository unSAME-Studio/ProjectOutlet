extends Node2D


export (PackedScene) var outlet
export (PackedScene) var plug

const GRID_SIZE = 200


func _ready():
	Global.grid = self
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
			p.additional_outlets.append(info[5])
		
		p.original_point = Vector2(OS.get_real_window_size().x / plugs_count * i - OS.get_real_window_size().x / 2, OS.get_real_window_size().y - 200)
		get_parent().call_deferred("add_child", p)
	
