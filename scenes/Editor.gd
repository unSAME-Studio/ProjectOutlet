extends Node


var plug = preload("res://objects/Plug.tscn")


var current_level = {
	"outlet": [
	],
	"plugs": [
	]
}

func _ready():
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("One")
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("TWO")
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("ALL")


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var position = $Node2D/TileMap.world_to_map(event.position)
			print(position)


func _on_SpawnPlug_pressed():
	var info = [
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Sizex".get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Sizey".get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Headx".get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Heady".get_text()),
	$"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type".get_selected()
	]
	
	current_level.plugs.append(info)
	
	$"CanvasLayer/Control/PanelContainer/VBoxContainer/ItemList".add_item("Size (%d, %d), Head (%d, %d), Type %d" % info)
	
	spawn_plug(info)
	
	export_level()


func spawn_plug(info):
	if $Node2D/Plugs.get_child_count() > 0:
		for i in $Node2D/Plugs.get_children():
			i.queue_free()
		
	var p = plug.instance()
	
	p.size = Vector2(info[0], info[1])
	p.head_position = Vector2(info[2], info[3])
	
	# set outlet type from data
	if info.size() >= 5:
		p.outlet_type = info[4]
	
	p.original_point = Vector2(0, 0)
	$Node2D/Plugs.add_child(p)


func export_level():
	print(current_level)


func _on_Remove_pressed():
	var itemlist = $"CanvasLayer/Control/PanelContainer/VBoxContainer/ItemList"
	if not itemlist.is_anything_selected():
		return
	
	if $Node2D/Plugs.get_child_count() > 0:
		for i in $Node2D/Plugs.get_children():
			i.queue_free()
	
	for i in itemlist.get_selected_items():
		current_level.plugs.remove(i)
		itemlist.remove_item(i)
	
	export_level()
