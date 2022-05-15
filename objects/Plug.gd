extends Area2D

export (PackedScene) var outlet
export (PackedScene) var string
var selected = false
var original_point
var rest_point

const GRID_SIZE = 64
var head_position = Vector2(0, 0)
var size = Vector2(2, 3)

var rotation_matrix = [Vector2(1, 1), Vector2(1, -1), Vector2(1, 1), Vector2(1, -1)]
var direction = 0


# drag and drop code adapted from Youtube
# https://www.youtube.com/watch?v=iSpWZzL2i1o


func _ready():
	# add this plug to the avaliable plugs
	Global.console.avaliable_plugs[self] = 0
	
	original_point = get_global_position()
	
	# set up graphics
	$Body.set_polygon(PoolVector2Array([
		Vector2(0, 0),
		Vector2(size.x * GRID_SIZE, 0),
		Vector2(size.x * GRID_SIZE, size.y * GRID_SIZE),
		Vector2(0, size.y * GRID_SIZE)
	]))
	$Body.set_position((-head_position * GRID_SIZE) - Vector2(GRID_SIZE / 2, GRID_SIZE / 2))
	
	var shape = RectangleShape2D.new()
	shape.set_extents(size * GRID_SIZE / 2)
	$CollisionShape2D.set_shape(shape)
	$CollisionShape2D.set_position($Body.get_position() + size * GRID_SIZE / 2)
	#$CollisionShape2D.set_position((-head_position * GRID_SIZE) + Vector2(0, GRID_SIZE / 2))
	
	# move attach point
	$End.set_position(Vector2(0, (size.y - head_position.y) * GRID_SIZE - GRID_SIZE / 2))
	
	# spawn the string
	var s = string.instance()
	s.plug = $"End"
	get_parent().call_deferred("add_child", s)
	s.set_global_position(Vector2(rand_range(0, get_viewport().size.x), get_viewport().size.y * 2))


# on drag
func _on_Plug_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click") and not get_tree().is_input_handled():
		selected = true
		get_tree().set_input_as_handled()
		
		$Out.play()


func _physics_process(delta):
	if selected:
		set_global_position(lerp(get_global_position(), get_global_mouse_position(), 25 * delta))
	else:
		if rest_point:
			set_global_position(lerp(get_global_position(), rest_point.get_global_position(), 10 * delta))
		else:
			set_global_position(lerp(get_global_position(), original_point, 10 * delta))


# on drop
func _input(event):
	if selected:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and not event.pressed:
				selected = false
				
				# detect outlet
				var shortest_dist = 75
				var closest_point = null
				for child in get_tree().get_nodes_in_group("outlet"):
					var distance = global_position.distance_to(child.get_global_position())
					if distance < shortest_dist:
						closest_point = child
						shortest_dist = distance
				
				if rest_point:
					rest_point.deselect()
				
				# if found another close point, select it
				# else send back to original point
				# check for overlapping tiles (IMPORTANT)
				if closest_point and closest_point.check_fit(self):
					rest_point = closest_point
					rest_point.select()
					
					Global.console.avaliable_plugs.erase(self)
					Global.console.attached_plugs[self] = 0
					
					Global.console.detect_complete()
					
					$In.play()
					
					print("Avaliable")
					print(Global.console.avaliable_plugs)
					print("Attached")
					print(Global.console.attached_plugs)
				else:
					rest_point = null
					
					Global.console.avaliable_plugs[self] = 0
					Global.console.attached_plugs.erase(self)
					
					print("Avaliable")
					print(Global.console.avaliable_plugs)
					print("Attached")
					print(Global.console.attached_plugs)
	
		# rotating
		if Input.is_action_just_pressed("rotate"):
			spin()


func spin():
	direction += 1
	if direction >= 4:
		direction = 0
		
	print("!! current direction %d" % [direction])
	
	# do the magic number flipping thingy
	#if not direction % 2 == 0:
	#	size.y *= -1
	
	# move head position
	# MAGIC (COPYRIGHTED pending)
	# (c) 2022 Sam Feng jk
	head_position = Vector2(size.y - 1 - head_position.y, head_position.x)
	print("New head position %s" % [head_position])
	
	# swap size x and y
	var temp_size = size
	size.x = temp_size.y
	size.y = temp_size.x
	
	print(size)
	
	set_rotation(get_rotation() + PI / 2)
