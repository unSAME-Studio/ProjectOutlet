extends Node2D


export (PackedScene) var outlet
export (PackedScene) var plug

var outlet_size = 64


func _ready():
	Global.grid = self
	var grid = Global.current_level_data["grid"]
	
	for r in range(grid.size()):
		for c in range(grid[r].size()):
			
			# check if slot is true
			if grid[r][c] == 1:
			
				print("Current at %d x %d" % [c, r])
				
				# generate the grid
				var o = outlet.instance()
				o.grid_position = Vector2(c, r)
				add_child(o)
				o.set_position(Vector2(c * outlet_size, r * outlet_size))
	
	# spawn all the plugs
	for i in range(Global.current_level_data["plugs"].size()):
		var p = plug.instance()
		p.size = Global.current_level_data["plugs"][i][0]
		p.head_position = Global.current_level_data["plugs"][i][1]
		p.original_point = Vector2(i * 100 - 100, 350)
		get_parent().call_deferred("add_child", p)
	
