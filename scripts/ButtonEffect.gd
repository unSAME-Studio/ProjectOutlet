extends TextureButton



func _ready():
	if OS.get_name() in ["Windows", "OSX", "HTML5","X11"]:
		connect("mouse_entered", self, "_on_hover")
		connect("mouse_exited", self, "_on_mouse_exit")
	
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")
	
	var t = Tween.new()
	t.name = "Tween"
	add_child(t)


func _on_button_down():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_scale",
			get_scale(), Vector2(0.8, 0.8), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func _on_button_up():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_scale",
			get_scale(), Vector2(1.2, 1.2), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func _on_hover():
	if is_disabled():
		return
	
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_scale",
			get_scale(), Vector2(1.2, 1.2), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func _on_mouse_exit():
	if is_disabled():
		return
	
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_scale",
			get_scale(), Vector2(1, 1), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
