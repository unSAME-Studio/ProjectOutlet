extends Position2D

signal select
signal deselect


func select():
	emit_signal("select")
	modulate = Color.blue

func deselect():
	emit_signal("deselect")
	modulate = Color.white
