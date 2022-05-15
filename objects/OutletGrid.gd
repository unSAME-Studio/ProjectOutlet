extends Node2D


export (PackedScene) var outlet
export (PackedScene) var plug

var outlet_size = 64


func _ready():
	Global.grid = self
	var grid = Global.console.level["grid"]
	
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
	for pos in Global.console.level["plugs"]:
		print("Spawning Plug at %s" % [pos])
		var p = plug.instance()
		p.size = pos
		add_child(p)
		p.move_local_y(100)
	
