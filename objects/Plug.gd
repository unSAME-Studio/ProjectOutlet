extends Area2D

export (PackedScene) var outlet
export (PackedScene) var string
var selected = false
var original_point
var rest_point
var closest_point = null

const GRID_SIZE = 200
const MARGIN = 20
var head_position = Vector2(0, 0)
var size = Vector2(2, 3)

var direction = 0

enum TYPE {ONE, TWO, ALL}
var outlet_type = TYPE.TWO

var cable

# drag and drop code adapted from Youtube
# https://www.youtube.com/watch?v=iSpWZzL2i1o


func _ready():
	# add this plug to the avaliable plugs
	Global.console.avaliable_plugs[self] = 0
	
	# change head sprite
	match outlet_type:
		TYPE.ONE:
			$Head.set_texture(load("res://arts/Temp_OutletAlt.png"))
		TYPE.TWO:
			pass
		TYPE.ALL:
			$Head.set_texture("res://arts/Temp_OutletAll.png")
	
	# set up graphics
	$Body.set_polygon(PoolVector2Array([
		Vector2(0 + MARGIN, 0 + MARGIN),
		Vector2(size.x * GRID_SIZE - MARGIN, 0 + MARGIN),
		Vector2(size.x * GRID_SIZE - MARGIN, size.y * GRID_SIZE - MARGIN),
		Vector2(0 + MARGIN, size.y * GRID_SIZE - MARGIN)
	]))
	$Body.uv = PoolVector2Array([
		Vector2(0.0, 0.0),
		Vector2(0.0, 501.0),
		Vector2(501.0, 501.0),
		Vector2(501.0, 0.0),
	])
	$Body.set_position((-head_position * GRID_SIZE) - Vector2(GRID_SIZE / 2, GRID_SIZE / 2))
	
	var shape = RectangleShape2D.new()
	shape.set_extents(size * GRID_SIZE / 2)
	$CollisionShape2D.set_shape(shape)
	$CollisionShape2D.set_position($Body.get_position() + size * GRID_SIZE / 2)
	#$CollisionShape2D.set_position((-head_position * GRID_SIZE) + Vector2(0, GRID_SIZE / 2))
	
	# move attach point
	$End.set_position(Vector2(0, (size.y - head_position.y) * GRID_SIZE - GRID_SIZE / 2 - MARGIN))
	
	# spawn the string
	cable = string.instance()
	cable.plug = $"End"
	get_parent().call_deferred("add_child", cable)
	cable.set_global_position(Vector2(original_point.x, OS.get_real_window_size().y))


# on drag
func _on_Plug_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click") and not get_tree().is_input_handled():
		selected = true
		get_tree().set_input_as_handled()
		
		$Out.play()
		set_modulate(Color(1,1,1,0.5))
		cable.set_modulate(Color(1,1,1,0.5))


func _process(delta):
	if selected:
		# continueous detection
		closest_point = null
		var shortest_dist = 100
		
		# detect outlet
		for child in get_tree().get_nodes_in_group("outlet"):
			var distance = get_global_mouse_position().distance_to(child.get_global_position())
			if distance < shortest_dist:
				closest_point = child
				shortest_dist = distance
		
		if closest_point:
			set_global_position(lerp(get_global_position(), closest_point.get_global_position(), 25 * delta))
		else:
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
				
				set_modulate(Color(1,1,1,1))
				cable.set_modulate(Color(1,1,1,1))
				
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
					
					$Body.set_color(Color("2f936d"))
					$Head.set_modulate(Color("2f936d"))
					cable.get_node("Line2D").set_default_color(Color("2f936d"))
					
					set_z_index(4)
					
					print("Avaliable")
					print(Global.console.avaliable_plugs)
					print("Attached")
					print(Global.console.attached_plugs)
					
				else:
					rest_point = null
					
					Global.console.avaliable_plugs[self] = 0
					Global.console.attached_plugs.erase(self)
					
					$Body.set_color(Color("939393"))
					$Head.set_modulate(Color("ffffff"))
					cable.get_node("Line2D").set_default_color(Color("939393"))
					
					set_z_index(6)
					
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
	
	# move head position
	# MAGIC
	head_position = Vector2(size.y - 1 - head_position.y, head_position.x)
	print("New head position %s" % [head_position])
	
	# swap size x and y
	var temp_size = size
	size.x = temp_size.y
	size.y = temp_size.x
	
	print(size)
	
	#set_rotation(get_rotation() + PI / 2)
	
	var tween = get_node("Tween")
	var target_rotation = direction * PI / 2
	tween.interpolate_property(self, "rotation",
			get_rotation(), target_rotation, 0.15,
			Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
