extends Position2D


func select():
	for child in get_tree().get_nodes_in_group("outlet"):
		child.deselect()
	modulate = Color.blue

func deselect():
	modulate = Color.white
