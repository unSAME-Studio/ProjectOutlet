extends Node

var console
var grid
var main


var hover_plugs = []

enum TYPE {ONE, TWO, ALL}

# data structure
# outlet is based on grid + rot
# plug : [ Size.x, Size.y, Head.x, Head.y, Type, AdditionalOutlet [Pos.x, Pos.y, Type, Rot] ]

var current_level = 1
var current_level_data setget ,level_data_get
var level = {
	1: {
		"grid": [
			[2],
			[2],
			[2],
		],
		"plugs": [
			[1, 2, 0, 0],
		],
		"hint": "[center]Tap to Rotate[/center]\n[center]Drag to Move[/center]"
	},
	2: {
		"grid": [
			[2],
			[2]
		],
		"plugs": [
			[1, 2, 0, 0],
			[1, 1, 0, 0],
		],
		"hint": "[center]Fit all the plugs[/center][center]on the outlets[/center]"
	},
	3: {
		"grid": [
			[2],
			[1],
			[1],
			[2]
		],
		"rot": [
			[0],
			[1],
			[3],
			[0]
		],
		"plugs": [
			[1, 2, 0, 0],
			[1, 1, 0, 0, TYPE.ONE],
			[1, 1, 0, 0, TYPE.ONE],
			[2, 3, 0, 0]
		],
		"hint": "[center]Match the plugs[/center][center]to their outlets[/center]"
	},
	4: {
		"grid": [
			[0, 0, 2],
			[0, 0, 1],
			[2, 1, 2]
		],
		"rot": [
			[0, 0, 0],
			[0, 0, 0],
			[0, 2, 0]
		],
		"plugs": [
			[1, 3, 0, 1],
			[2, 3, 1, 0],
			[2, 2, 1, 1, TYPE.ONE],
		]
	},
	5: {
		"grid": [
			[0, 1, 0],
			[2, 1, 2],
			[0, 1, 0]
		],
		"plugs": [
			[2, 2, 0, 0],
			[1, 2, 0, 0],
			[3, 1, 1, 0],
			[1, 3, 0, 0],
			[1, 1, 0, 0],
		]
	},
	6: {
		"grid": [
			[1, 1],
			[1, 1],
			[2, 2]
		],
		"rot": [
			[1, 3],
			[1, 3],
			[1, 1]
		],
		"plugs": [
			[2, 2, 0, 0],
			[2, 2, 1, 0, TYPE.ONE],
			[3, 2, 0, 0],
			[1, 2, 0, 0, TYPE.ONE],
			[1, 1, 0, 0, TYPE.ONE],
		]
	},
	7: {
		"grid": [
			[2, 3, 0],
			[0, 3, 0],
			[0, 2, 3]
		],
		"rot": [
			[0, 0, 0],
			[0, 0, 0],
			[0, 1, 0]
		],
		"plugs": [
			[1, 2, 0, 0],
			[1, 2, 0, 0],
			[1, 2, 0, 0, TYPE.ALL],
			[1, 2, 0, 0, TYPE.ALL],
			[1, 1, 0, 0, TYPE.ALL],
		]
	},
	8: {
		"grid": [
			[1],
		],
		"plugs": [
			[1, 3, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 2, 0, 0],
		],
		"hint": "[center]Some plugs have an additional outlet[/center]"
	},
	9: {
		"grid": [
			[0, 1],
			[1, 0],
		],
		"rot": [
			[0, 0],
			[0, 0],
		],
		"plugs": [
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.ONE, 3]]],
			[1, 2, 0, 0, TYPE.ONE],
			[1, 2, 0, 0, TYPE.ONE],
		],
	},
	10: {
		"grid": [
			[2, 2],
		],
		"rot": [
			[1, 0],
			[1, 1],
		],
		"plugs": [
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 2, 0, 0, TYPE.TWO, [[0, 1, TYPE.TWO, 1]]],
			[1, 1, 0, 0],
			[1, 1, 0, 0],
		],
		"hint": "[center]How far can you stack?[/center]"
	},
	11: {"outlets":[[0, 0, 1, 0], [1, 0, 1, 3], [1, 1, 1, 0], [0, 1, 1, 1]], "plugs":[[1, 4, 0, 0, 1], [1, 4, 0, 0, 1], [1, 4, 0, 0, 1], [1, 4, 0, 0, 1]], "size":[2, 2]},
	12: {
		"grid": [
			[1, 1, 0, 1, 0, 1, 0, 0, 1],
			[1, 0, 0, 1, 0, 1, 1, 0, 1],
			[1, 1, 0, 1, 0, 1, 0, 1, 1],
			[1, 0, 0, 1, 0, 1, 0, 0, 1]
		],
		"plugs": [],
		"hint": "[center]Thank you for playing![/center]"
	}
}


func _ready():
	pass


func level_data_get():
	return Global.level[Global.current_level]


func load_database(file_name: String):
	var data_file = File.new()
	data_file.open("res://%s.json" % file_name, File.READ)
	
	var database = parse_json(data_file.get_as_text())
	
	data_file.close()
	
	return database
