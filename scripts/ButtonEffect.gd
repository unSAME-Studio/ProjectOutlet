extends TextureButton



func _ready():
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_mouse_exit")
	
	var t = Tween.new()
	t.name = "Tween"
	add_child(t)


func _on_hover():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_scale",
			Vector2(1, 1), Vector2(1.2, 1.2), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func _on_mouse_exit():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_scale",
			Vector2(1.2, 1.2), Vector2(1, 1), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
