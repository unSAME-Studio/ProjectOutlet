extends Node2D

export (float) var ropeLength = 30
export (float) var constrain = 1	# distance between points
export (Vector2) var gravity = Vector2(0, 0)
export (float) var dampening = 0.7
export (bool) var startPin = true
export (bool) var endPin = true

onready var line2D: = $Line2D

var pos: PoolVector2Array
var posPrev: PoolVector2Array
var pointCount: int

var head_end
var plug_end
var plug_end_tan

onready var curve = Curve2D.new()

func _ready()->void:
	#pointCount = get_pointCount(ropeLength)
	#resize_arrays()
	#init_position()
	
	# set P0 to end
	$P0.set_global_position(head_end)
	$P0/P1.set_global_position($P0.get_global_position() + Vector2(0, -200))
	pass

func get_pointCount(distance: float)->int:
	return int(ceil(distance / constrain))

func resize_arrays():
	pos.resize(pointCount)
	posPrev.resize(pointCount)

func init_position()->void:
	for i in range(pointCount):
		pos[i] = position + Vector2(constrain *i, 0)
		posPrev[i] = position + Vector2(constrain *i, 0)
	position = Vector2.ZERO

"""
func _unhandled_input(event:InputEvent)->void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("click"):	#Move start point
			set_start(get_global_mouse_position())
		if Input.is_action_pressed("right_click"):	#Move start point
			set_last(get_global_mouse_position())
	elif event is InputEventMouseButton && event.is_pressed():
		if event.button_index == 1:
			set_start(get_global_mouse_position())
		elif event.button_index == 2:
			set_last(get_global_mouse_position())
"""

func _process(delta)->void:
	#if plug:
	#	set_last(plug.get_global_position())
	
	#update_points(delta)
	#update_constrain()
	
	#update_constrain()	#Repeat to get tighter rope
	#update_constrain()
	
	# Send positions to Line2D for drawing
	#line2D.points = pos
	
	# calculate curve
	#$P0.look_at(plug_end.get_global_position())
	
	var p0_in = Vector2.ZERO # This isn't used for the first curve
	var p0_vertex = $P0.get_global_position() # First point of first line segment
	var p0_out = $P0/P1.get_global_position() - $P0.get_global_position() # Second point of first line segment
	var p1_in = plug_end_tan.get_global_position() - plug_end.get_global_position() # First point of second line segment
	var p1_vertex = plug_end.get_global_position() # Second point of second line segment
	var p1_out = Vector2.ZERO # Not used unless another curve is added
	curve.add_point(p0_vertex, p0_in, p0_out)
	curve.add_point(p1_vertex, p1_in, p1_out)
	
	line2D.points = curve.tessellate()
	
	curve.clear_points()

func set_start(p:Vector2)->void:
	pos[0] = p
	posPrev[0] = p

func set_last(p:Vector2)->void:
	pos[pointCount-1] = p
	posPrev[pointCount-1] = p

func update_points(delta)->void:
	for i in range (pointCount):
		# not first and last || first if not pinned || last if not pinned
		if (i!=0 && i!=pointCount-1) || (i==0 && !startPin) || (i==pointCount-1 && !endPin):
			var velocity = (pos[i] -posPrev[i]) * dampening
			posPrev[i] = pos[i]
			pos[i] += velocity + (gravity * delta)

func update_constrain()->void:
	for i in range(pointCount):
		if i == pointCount-1:
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		
		# if first point
		if i == 0:
			if startPin:
				pos[i+1] += vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
		# if last point, skip because no more points after it
		elif i == pointCount-1:
			pass
		# all the rest
		else:
			if i+1 == pointCount-1 && endPin:
				pos[i] -= vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
