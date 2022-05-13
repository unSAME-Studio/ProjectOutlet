extends Node


var level = [
			[1, 1],
			[0, 1],
			[0, 1],
			[1, 1]
			]

var avaliable_plugs = {}
var attached_plugs = {}

func _ready():
	Global.console = self
