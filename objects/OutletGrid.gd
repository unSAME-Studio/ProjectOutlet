extends Node2D


export (PackedScene) var outlet


var outlet_size = 80


func _ready():
	Global.grid = self
	
	for r in range(Global.console.level.size()):
		for c in range(Global.console.level[r].size()):
			
			print("Current at %d x %d" % [c, r])
			
			# generate the grid
			var o = outlet.instance()
			o.grid_position = Vector2(c, r)
			add_child(o)
			o.set_position(Vector2(c * outlet_size, r * outlet_size))
