extends Node

enum TYPE {ONE, TWO, ALL}

# data structure
# outlet is based on grid + rot
# plug : [ Size.x, Size.y, Head.x, Head.y, Type, AdditionalOutlet [Pos.x, Pos.y, Type, Rot] ]

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
		"hint": "[center]Tap to Rotate[/center]\n[center]Drag to Move[/center]"
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
			[1, 1, 0, 0],
			[1, 1, 0, 0],
			[2, 3, 0, 0]
		]
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
			[0, 3, 0],
			[2, 1, 2],
			[0, 3, 0]
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
			[2, 2, 1, 0],
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
			[1, 2, 0, 0],
			[1, 2, 0, 0],
			[1, 1, 0, 0, TYPE.ALL],
		]
	},
	8: {
		"grid": [
			[2, 0],
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
			[1, 1, 0, 0],
			[1, 1, 0, 0],
		],
		"hint": "[center]Some plugs have additional outlet[/center]"
	},
	9: {
		"grid": [
			[1, 1, 0, 1, 0, 1, 0, 0, 1],
			[1, 0, 0, 1, 0, 1, 1, 0, 1],
			[1, 1, 0, 1, 0, 1, 0, 1, 1],
			[1, 0, 0, 1, 0, 1, 0, 0, 1]
		],
		"plugs": []
	}
}


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
	Global.main.game_finished()


func next_level():
	Global.current_level += 1
	get_tree().reload_current_scene()
