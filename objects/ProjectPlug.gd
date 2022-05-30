extends Node

var head_position = Vector2(0, 0)
var size = Vector2(2, 3)
var direction = 0
var outlet_type = 0


func spin_clockwise():
	direction = wrapi(direction + 1, 0, 4)
	
	# move head position
	head_position = Vector2(size.y - 1 - head_position.y, head_position.x)
	
	# swap size x and y
	var temp_size = size
	size.x = temp_size.y
	size.y = temp_size.x


func spin_counterclockwise():
	direction = wrapi(direction - 1, 0, 4)
		
	# move head position
	head_position = Vector2(head_position.y, size.x - 1 - head_position.x)
	
	# swap size x and y
	var temp_size = size
	size.x = temp_size.y
	size.y = temp_size.x
