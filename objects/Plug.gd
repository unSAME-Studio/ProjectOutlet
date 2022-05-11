extends Area2D


var selected = false
var rest_point
var rest_nodes = []

# drag and drop code adapted from Youtube
# https://www.youtube.com/watch?v=iSpWZzL2i1o

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("outlet")
	rest_point = get_global_position()

# on drag
func _on_Plug_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true


func _physics_process(delta):
	if selected:
		set_global_position(lerp(get_global_position(), get_global_mouse_position(), 25 * delta))
	else:
		set_global_position(lerp(get_global_position(), rest_point, 10 * delta))

# on drop
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			
			# detect outlet
			var shortest_dist = 75
			for child in rest_nodes:
				var distance = global_position.distance_to(child.get_global_position())
				if distance < shortest_dist:
					child.select()
					rest_point = child.get_global_position()
					shortest_dist = distance
			
