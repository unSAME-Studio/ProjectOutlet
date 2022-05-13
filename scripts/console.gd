extends Node


var level = [
			[0, 0],
			[0],
			[0],
			[0]
			]

var avaliable_plugs = {}
var attached_plugs = {}

func _ready():
	Global.console = self
