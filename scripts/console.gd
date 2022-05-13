extends Node


var level = {
	"grid": [
		[1, 1],
		[0, 1],
		[0, 1],
		[1, 1]
	],
	"plugs": [
		Vector2(1, 2),
		Vector2(1, 1),
		Vector2(1, 1),
		Vector2(2, 3)
	]
}


var avaliable_plugs = {}
var attached_plugs = {}

func _ready():
	Global.console = self
