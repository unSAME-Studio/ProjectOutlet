extends Node

enum TYPE {ONE, TWO, ALL}


var level = {
	1: {
		"grid": [
			[2],
			[2],
			[2],
		],
		"plugs": [
			[1, 2, 0, 0],
		]
	},
	2: {
		"grid": [
			[2],
			[2],
		],
		"plugs": [
			[1, 2, 0, 0],
			[1, 1, 0, 0],
		]
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
	
	$"../CanvasLayer/Control/Level".set_text("Level: %d" % Global.current_level)


func detect_complete():
	if avaliable_plugs.size() == 0:
		game_finished()


func game_finished():
	$"../CanvasLayer/Control/Tag".show()


func next_level():
	Global.current_level += 1
	get_tree().reload_current_scene()
