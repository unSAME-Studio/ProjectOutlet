extends Area2D

export (PackedScene) var outlet

var selected = false
var rest_point
var original_point

# drag and drop code adapted from Youtube
# https://www.youtube.com/watch?v=iSpWZzL2i1o


func _ready():
	var o = outlet.instance()
	o.set_global_position(get_global_position())
	get_parent().call_deferred("add_child", o)
	o.remove_from_group("outlet")
	original_point = o
	rest_point = original_point


# on drag
func _on_Plug_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click") and not get_tree().is_input_handled():
		selected = true
		get_tree().set_input_as_handled()


func _physics_process(delta):
	if selected:
		set_global_position(lerp(get_global_position(), get_global_mouse_position(), 25 * delta))
	else:
		set_global_position(lerp(get_global_position(), rest_point.get_global_position(), 10 * delta))

# on drop
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			
			# detect outlet
			var shortest_dist = 75
			var closest_point = original_point
			for child in get_tree().get_nodes_in_group("outlet"):
				var distance = global_position.distance_to(child.get_global_position())
				if distance < shortest_dist:
					closest_point = child
					shortest_dist = distance
			
			# if found another close point, select it
			# else send back to original point
			rest_point.deselect()
			rest_point = closest_point
			rest_point.select()
