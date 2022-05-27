extends Area2D

export (PackedScene) var outlet
export (PackedScene) var string

var hovering = false
var selected = false
const HOLD_REQUIRED = 0.5
var holding = false
var hold_time = 0
const DRAG_DISTANCE = 40
var drag_point = Vector2.ZERO

var original_point
var rest_point
var closest_point = null

const GRID_SIZE = 200
const MARGIN = 15
const CORNER = 10
var head_position = Vector2(0, 0)
var size = Vector2(2, 3)

var direction = 0

enum TYPE {ONE, TWO, ALL}
var outlet_type = TYPE.TWO

var additional_outlets = [
	
]

var cable

# drag and drop code adapted from Youtube
# https://www.youtube.com/watch?v=iSpWZzL2i1o


func _ready():
	# add this plug to the avaliable plugs
	Global.console.avaliable_plugs[self] = 0
	
	# change head sprite
	match outlet_type:
		TYPE.ONE:
			$Head.set_texture(load("res://arts/anti_plug_one.png"))
		TYPE.TWO:
			pass
		TYPE.ALL:
			$Head.set_texture(load("res://arts/anti_plug_multi.png"))
	
	# set up graphics
	$Body.set_polygon(PoolVector2Array([
		Vector2(0 + MARGIN, 0 + MARGIN),
		Vector2(0 + MARGIN + CORNER, 0 + MARGIN),
		Vector2(size.x * GRID_SIZE - MARGIN - CORNER, 0 + MARGIN),
		Vector2(size.x * GRID_SIZE - MARGIN, 0 + MARGIN),
		Vector2(size.x * GRID_SIZE - MARGIN, 0 + MARGIN + CORNER),
		Vector2(size.x * GRID_SIZE - MARGIN, size.y * GRID_SIZE - MARGIN - CORNER),
		Vector2(size.x * GRID_SIZE - MARGIN, size.y * GRID_SIZE - MARGIN),
		Vector2(size.x * GRID_SIZE - MARGIN - CORNER, size.y * GRID_SIZE - MARGIN),
		Vector2(0 + MARGIN + CORNER, size.y * GRID_SIZE - MARGIN),
		Vector2(0 + MARGIN, size.y * GRID_SIZE - MARGIN),
		Vector2(0 + MARGIN, size.y * GRID_SIZE - MARGIN - CORNER),
		Vector2(0 + MARGIN, 0 + MARGIN + CORNER),
	]))
	$Body.uv = PoolVector2Array([
		Vector2(0.0, 0.0),
		Vector2(0.0 + CORNER, 0.0),
		Vector2(200.0 - CORNER, 0.0),
		Vector2(200.0, 0.0),
		Vector2(200.0, 0.0 + CORNER),
		Vector2(200.0, 200.0 - CORNER),
		Vector2(200.0, 200.0),
		Vector2(200.0 - CORNER, 200.0),
		Vector2(0.0 + CORNER, 200.0),
		Vector2(0.0, 200.0),
		Vector2(0.0, 200.0 - CORNER),
		Vector2(0.0, 0.0 + CORNER),
	])
	$Body.set_offset(-size * GRID_SIZE / 2)
	$Body.set_position(((-head_position * GRID_SIZE) - Vector2(GRID_SIZE / 2, GRID_SIZE / 2)) + (size * GRID_SIZE / 2))
	
	$Outline.set_polygon($Body.get_polygon())
	$Outline.uv = $Body.uv
	$Outline.set_offset($Body.get_offset())
	$Outline.set_position($Body.get_position())
	
	var shape = RectangleShape2D.new()
	shape.set_extents(size * GRID_SIZE / 2)
	$CollisionShape2D.set_shape(shape)
	$CollisionShape2D.set_position($Body.get_position())
	
	# move attach point
	$End.set_position(Vector2(0, (size.y - head_position.y) * GRID_SIZE - GRID_SIZE / 2 - MARGIN))
	$End2.set_position($End.get_position() + Vector2(0, 200))
	
	# spawn the string
	cable = string.instance()
	cable.plug_end = $End
	cable.plug_end_tan = $End2
	cable.head_end = Vector2(original_point.x, get_viewport_rect().size.y / 2)
	
	get_parent().add_child(cable)
	#cable.set_global_position(Vector2(original_point.x, OS.get_real_window_size().y))
	
	# initialize color
	set_modulate(ColorManager.color.main_light)
	cable.set_modulate(ColorManager.color.main_light)
	$Outline.set_color(ColorManager.color.main_dark)
	$Outlets.set_modulate(ColorManager.color.second)
	$Head.set_modulate(ColorManager.color.main_dark)
	
	# spawn additional outlets
	for i in additional_outlets:
		var o = outlet.instance()
		
		o.initialize(Vector2(0, 0), i[2], i[3])
		o.offset_position = Vector2(i[0], i[1])
		o.host_plug = self
		o.enabled = false
		o.hide_outline()
		
		$Outlets.add_child(o)
		
		o.set_position((Vector2(i[0], i[1]) - head_position) * 200)


# on drag
func _on_Plug_input_event(viewport, event, shape_idx):
	if hovering and not get_tree().is_input_handled():
		get_tree().set_input_as_handled()
		
		if Input.is_action_just_pressed("click"):
			get_tree().set_input_as_handled()
			holding = true
			drag_point = get_global_mouse_position()
			print("Grabbing -> %s" % name)
		
		# rotating
		if event is InputEventMouseButton:
			if event.pressed:
				match event.button_index:
					BUTTON_WHEEL_UP:
						if rest_point == null:
							spin_clockwise()
						else:
							set_rotation_degrees(get_rotation_degrees() + 20)
					BUTTON_WHEEL_DOWN:
						if rest_point == null:
							spin_counterclockwise()
						else:
							set_rotation_degrees(get_rotation_degrees() - 20)


func _process(delta):
	# check for release event
	if Input.is_action_just_released("click"):
		hold_time = 0.0
			
		if holding:
			holding = false
			
			if rest_point == null:
				spin_clockwise()
				print("Release with no hold")
			else:
				#play can't rotate animation
				#$AnimationPlayer.stop()
				#$AnimationPlayer.play("bad_rotate")
				set_rotation_degrees(get_rotation_degrees() + 20)
	
	# check for holding
	if not selected and holding:
		
		# check for timing
		hold_time += delta
		if hold_time >= HOLD_REQUIRED:
			holding = false
			hold_time = 0.0
			
			selected = true
			get_node("In%d" % (randi() % 2)).play()
			$AnimationPlayer.stop()
			$AnimationPlayer.play("body_hint")
			
			modulate.a = 0.5
			cable.modulate.a = 0.5
			
			unplug()
		
		# check for distance
		#print(get_global_mouse_position().distance_to(drag_point))
		if get_global_mouse_position().distance_to(drag_point) >= DRAG_DISTANCE:
			holding = false
			hold_time = 0.0
			
			selected = true
			get_node("In%d" % (randi() % 2)).play()
			$AnimationPlayer.stop()
			$AnimationPlayer.play("body_hint")
			
			modulate.a = 0.5
			cable.modulate.a = 0.5
			
			unplug()
	
	
	if selected:
		# rotating when selected
		if Input.is_action_just_pressed("rotate"):
			spin_clockwise()
		
		# continueous detection
		closest_point = null
		var shortest_dist = 100
		
		# detect outlet
		for child in get_tree().get_nodes_in_group("outlet"):
			var distance = get_global_mouse_position().distance_to(child.get_global_position())
			if distance < shortest_dist and child.check_enabled():
				closest_point = child
				shortest_dist = distance
		
		if closest_point:
			set_global_position(lerp(get_global_position(), closest_point.get_global_position(), 20 * delta))
			
			if closest_point.check_fit(self):
				set_modulate(ColorManager.color.main)
				cable.set_modulate(ColorManager.color.main)
			else:
				closest_point = null
				
				set_modulate(ColorManager.color.bad)
				cable.set_modulate(ColorManager.color.bad)
		
		else:
			set_global_position(lerp(get_global_position(), get_global_mouse_position(), 20 * delta))
			
			set_modulate(ColorManager.color.main_light)
			cable.set_modulate(ColorManager.color.main_light)
		
		# half transparency
		modulate.a = 0.5
		cable.modulate.a = 0.5
	
	else:
		if rest_point:
			set_global_position(lerp(get_global_position(), rest_point.get_global_position(), 10 * delta))
		else:
			set_global_position(lerp(get_global_position(), original_point, 10 * delta))
	
	# constantly rotate the plug
	set_rotation(lerp_angle(get_rotation(), direction * PI / 2, 25 * delta))
	
	# adjust end tangent base on cable distance
	var cable_distance = (cable.head_end.distance_to(get_global_position()) / 2)
	$End2.set_position($End.get_position() + Vector2(0, cable_distance))
	cable.get_node("P0/P1").set_position(Vector2(0, -cable_distance))
	
	# enlarge outline
	if hovering:
		#$Outline.set_scale(lerp($Outline.get_scale(), Vector2(1.2, 1.2), 25 * delta))
		set_scale(lerp(get_scale(), Vector2(1.1, 1.1), 25 * delta))
	else:
		#$Outline.set_global_position(lerp($Outline.get_global_position(), $Body.get_global_position() + Vector2(0, 20), 25 * delta))
		set_scale(lerp(get_scale(), Vector2(1, 1), 25 * delta))
	
	$Outline.set_global_position($Body.get_global_position() + Vector2(0, 20))


# on drop
func _input(event):
	if selected:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and not event.pressed:
				selected = false
				
				set_modulate(Color(1,1,1,1))
				cable.set_modulate(Color(1,1,1,1))
				
				# if found another close point, select it
				# else send back to original point
				# check for overlapping tiles (IMPORTANT)
				if closest_point:
					rest_point = closest_point
					rest_point.select(self)
					
					Global.console.avaliable_plugs.erase(self)
					Global.console.attached_plugs[self] = 0
					
					Global.console.detect_complete()
					
					get_node("Out%d" % (randi() % 2)).play()
					$AnimationPlayer.stop()
					$AnimationPlayer.play("body_hint")
					
					set_modulate(ColorManager.color.main)
					cable.set_modulate(ColorManager.color.main)
					
					set_z_index(rest_point.check_z_index() + 2)
					print("This plug is at %d Z INDEX" % get_z_index())
					
					#print("Avaliable")
					#print(Global.console.avaliable_plugs)
					#print("Attached")
					#print(Global.console.attached_plugs)
					
					# update all additional outlets
					for i in $Outlets.get_children():
						i.enabled = true
						
						# move the grid position
						i.grid_position = rest_point.grid_position + i.offset_position
						
						# check if any outlet is already in bottom
						# if yes then disable it
						for child in get_tree().get_nodes_in_group("outlet"):
							if i != child and i.grid_position == child.grid_position:
								child.enabled = false
						
				else:
					unplug()


func unplug():
	if rest_point != null:
		rest_point.deselect()
		rest_point = null
	
	Global.console.avaliable_plugs[self] = 0
	Global.console.attached_plugs.erase(self)
	
	set_modulate(ColorManager.color.main_light)
	cable.set_modulate(ColorManager.color.main_light)
	
	set_z_index(20)
	print("This plug is at %d Z INDEX" % get_z_index())
	
	#print("Avaliable")
	#print(Global.console.avaliable_plugs)
	#print("Attached")
	#print(Global.console.attached_plugs)
	
	# disable all additional outlet
	for i in $Outlets.get_children():
		i.enabled = false
		
		# restore additional outlet place
		# by finding the outlet with top z index
		var max_z_index = -1
		var top_outlet = null
		for child in get_tree().get_nodes_in_group("outlet"):
			if i != child and i.grid_position == child.grid_position:
				if child.get_z_index() > max_z_index:
					max_z_index = child.get_z_index()
					top_outlet = child
		
		if top_outlet:
			top_outlet.enabled = true
		
		# recursive unpluging
		for p in Global.console.attached_plugs:
			if p.rest_point == i:
				p.unplug()


func spin_clockwise():
	direction = wrapi(direction + 1, 0, 4)
		
	print("!! current direction %d" % [direction])
	
	# move head position
	# MAGIC
	head_position = Vector2(size.y - 1 - head_position.y, head_position.x)
	print("New head position %s" % [head_position])
	
	# swap size x and y
	var temp_size = size
	size.x = temp_size.y
	size.y = temp_size.x
	
	#set_rotation(get_rotation() + PI / 2)
	
	#var tween = get_node("Tween")
	#var target_rotation = direction * PI / 2
	#tween.interpolate_property(self, "rotation",
	#		get_rotation(), target_rotation, 0.15,
	#		Tween.TRANS_CIRC, Tween.EASE_OUT)
	#tween.start()
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("head_hint")
	
	# rotate and move the additional outlet
	for i in $Outlets.get_children():
		i.direction = wrapi(i.direction + 1, 0, 4)
		i.offset_position = Vector2(-i.offset_position.y, i.offset_position.x)
		print("ADDITIONAL: NEW POS %s" % i.offset_position)


func spin_counterclockwise():
	direction = wrapi(direction - 1, 0, 4)
		
	print("!! current direction %d" % [direction])
	
	# move head position
	# MAGIC
	head_position = Vector2(head_position.y, size.x - 1 - head_position.x)
	print("New head position %s" % [head_position])
	
	# swap size x and y
	var temp_size = size
	size.x = temp_size.y
	size.y = temp_size.x
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("head_hint")
	
	# rotate the additional outlet
	for i in $Outlets.get_children():
		i.direction = wrapi(i.direction - 1, 0, 4)
		i.offset_position = Vector2(-i.offset_position.y, i.offset_position.x)
		print("ADDITIONAL: NEW POS %s" % i.offset_position)


func _on_Plug_mouse_entered():
	hovering = true
	
	if Global.hover_plugs.size() > 0:
		# check the entire list, if z index is lower then ignore
		for i in Global.hover_plugs:
			if i.get_z_index() > get_z_index():
				hovering = false
				break
			else:
				i.hovering = false
		
	Global.hover_plugs.append(self)


func _on_Plug_mouse_exited():
	Global.hover_plugs.erase(self)
	hovering = false
	
	# find the top by z index and hover
	if Global.hover_plugs.size() > 0:
		var top_plug = null
		var top_z = -100
		for i in Global.hover_plugs:
			if i.get_z_index() > top_z:
				top_plug = i
				top_z = i.get_z_index()
		
		top_plug.hovering = true
