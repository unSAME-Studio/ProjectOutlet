extends Node


var previous_color = {}
var color = {
	"background": Color("5dc3ae"),
	"main": Color("44d29c"),
	"main_light": Color("44d29c"),
	"main_dark": Color("44d29c"),
	"second": Color("44d29c"),
	"tertiary": Color("44d29c"),
	"good": Color(0,0.5,0.5,0.5),
	"bad": Color(1,0.5,0.5,0.5),
}


func _ready():
	randomize()
	
	previous_color["background"] = color["background"]


func generate_color(hue = randf()):
	previous_color["background"] = color["background"]
	
	color.background = Color.from_hsv(hue, 0.3, 0.9, 1)
	color.main = Color.from_hsv(wrapf(hue + 0.01, 0.0, 1.0), 0.43, 0.8, 1)
	#color.main_light = color.main.lightened(0.7)
	color.main_light = Color.from_hsv(color.main.h, 0.1, 0.95, 1)
	color.main_dark = color.main.darkened(0.2)
	
	color.second = Color.from_hsv(wrapf(color.main.h + 0.1, 0.0, 1.0), 0.43, 0.8, 1)
	
	color.good = Color.from_hsv(wrapf(color.main.h + 0.25, 0.0, 1.0), 0.43, 0.8, 1)
	color.bad = Color.from_hsv(wrapf(color.good.h + 0.5, 0.0, 1.0), 0.43, 0.8, 1)
	
	# swap the color if good is in range
	if color.good.h > 0.7 or color.good.h < 0.07:
		var temp_bad = color.bad
		color.bad = color.good
		color.good = temp_bad 


func apply_color():
	VisualServer.set_default_clear_color(color.background)
