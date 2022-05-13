extends Position2D

signal select
signal deselect

var grid_position = Vector2(0, 0)


# code adapted from 
# https://tutorialedge.net/gamedev/aabb-collision-detection-tutorial/#:~:text=AABB%20Collision%20Detection%20or%20%22Axis,is%20axis%2Daligned%2C%20ie.


# a is new plug in coming
# b is other ones
func grid_aabb(a, b):
	var a_grid = grid_position - a.head_position
	var b_grid = b.rest_point.grid_position - b.head_position 
	
	print("comparing %s & %s" % [a_grid, b_grid])
	if(a_grid.x < b_grid.x + b.size.x and
	a_grid.x + a.size.x > b_grid.x and
	a_grid.y < b_grid.y + b.size.y and
	a_grid.y + a.size.y > b_grid.y):
		return true
	
	return false


# return true if possible for pluging in
# if collide with another plug then return
func check_empty(new_plug):
	var empty = true
	for plug in Global.console.attached_plugs.keys():
		# don't check if it's the same plug
		if new_plug == plug:
			continue
		
		if grid_aabb(new_plug, plug):
			empty = false
			break
	
	return empty


func select():	
	emit_signal("select")
	$"Polygon2D".color = Color("ffffff")

func deselect():
	emit_signal("deselect")
	$"Polygon2D".color = Color("c4c4c4")
