extends Position2D

signal select
signal deselect

var grid_position = Vector2(0, 0)
#var accepted_direction = [0, 2] #ODD EVEN CHECK DECIMAL 0.12
var direction = 0

enum TYPE {ONE, TWO, ALL}
var outlet_type = TYPE.TWO


func _ready():
	match outlet_type:
		TYPE.ONE:
			$Head.set_texture(load("res://arts/Temp_OutletAlt.png"))
		TYPE.TWO:
			pass
		TYPE.ALL:
			$Head.set_texture(load("res://arts/Temp_OutletAll.png"))
	
	# rotate the outlet
	$Head.set_rotation(direction * PI / 2)


# code adapted from 
# https://tutorialedge.net/gamedev/aabb-collision-detection-tutorial/#:~:text=AABB%20Collision%20Detection%20or%20%22Axis,is%20axis%2Daligned%2C%20ie.

# a is new plug in coming
# b is other ones
func grid_aabb(a, b):
	var a_grid = grid_position - a.head_position
	var b_grid = b.rest_point.grid_position - b.head_position 
	
	print(" -- comparing %s & %s" % [a_grid, b_grid])
	if(a_grid.x < b_grid.x + b.size.x and
	a_grid.x + a.size.x > b_grid.x and
	a_grid.y < b_grid.y + b.size.y and
	a_grid.y + a.size.y > b_grid.y):
		return true
	
	return false


# return true if possible for pluging in
func check_fit(new_plug):
	# check if type competable
	# (check for if ONE can't go in TWO && ALL only for ALL)
	if new_plug.outlet_type == TYPE.ALL and outlet_type != TYPE.ALL:
		return false
	
	if new_plug.outlet_type == TYPE.ONE and outlet_type == TYPE.TWO:
		return false
	
	# check direction based on plug type
	# the single plug also allow the plug in of two direction
	match outlet_type:
		TYPE.ONE:
			match new_plug.outlet_type:
				TYPE.ONE:
					if not new_plug.direction == direction:
						return false
				TYPE.TWO:
					if not (new_plug.direction + direction) % 2 == 0:
						return false
		TYPE.TWO:
			if not (new_plug.direction + direction) % 2 == 0:
				return false
		TYPE.ALL:
			pass
	
	# loop and check other plugs
	var fit = true
	for plug in Global.console.attached_plugs.keys():
		# don't check if it's the same plug
		if new_plug == plug:
			continue
		
		# check collision
		if grid_aabb(new_plug, plug):
			fit = false
			break
	
	return fit


func select():	
	emit_signal("select")
	$Head.modulate = Color("ffffff")

func deselect():
	emit_signal("deselect")
	$Head.modulate = Color("c4c4c4")
