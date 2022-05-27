extends Node

const GRID_SIZE = 200
var plug = preload("res://objects/Plug.tscn")
var outlet = preload("res://objects/Outlet.tscn")
export (ButtonGroup) var outlet_options

var current_level = {
	"outlets": [
	],
	"size": [],
	"plugs": [
	]
}
var plug_scene = [
	
]
var outlet_scene = {
	
}

func _ready():
	Global.main = self
	
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("One")
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("TWO")
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("ALL")


func game_finished():
	pass


func _unhandled_input(event):
	if not $"CanvasLayer/Control/PanelContainer2/HBoxContainer3/PlayMode".is_pressed():
		
		if Input.is_action_just_pressed("click"):
			var position = $Node2D/TileMap.world_to_map($Node2D/TileMap.to_local($Node2D.get_global_mouse_position()))
			var key = "%d:%d" % [position.x, position.y]
			
			# check if outlet already exist, if so rotate
			if outlet_scene.has(key):
				outlet_scene[key].rotate(wrapi(outlet_scene[key].direction + 1, 0, 4))
				return
			
			var type = int(outlet_options.get_pressed_button().name)
			
			var o = outlet.instance()
			o.initialize(position, type, 0)
			$Node2D/Outlets.add_child(o)
			print("Adding outlet at %s" % position)
			o.set_position(position * GRID_SIZE + Vector2(GRID_SIZE, GRID_SIZE) / 2)
			
			o.set_modulate(ColorManager.color.main_dark)
			
			outlet_scene[key] = o
		
		if Input.is_action_just_pressed("rotate"):
			var position = $Node2D/TileMap.world_to_map($Node2D/TileMap.to_local($Node2D.get_global_mouse_position()))
			var key = "%d:%d" % [position.x, position.y]
			# check if outlet already exist, if so rotate
			if outlet_scene.has(key):
				outlet_scene[key].queue_free()
				outlet_scene.erase(key)
				return
		
	if Input.is_action_pressed("camera"):
		$Node2D/Camera2D.set_global_position(lerp($Node2D/Camera2D.get_global_position(), $Node2D.get_global_mouse_position(), 0.1))


func _on_SpawnPlug_pressed():
	var info = [
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Sizex".get_line_edit().get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Sizey".get_line_edit().get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Headx".get_line_edit().get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Heady".get_line_edit().get_text()),
	$"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type".get_selected()
	]
	
	current_level.plugs.append(info)
	
	$"CanvasLayer/Control/PanelContainer/VBoxContainer/ItemList".add_item("Size (%d, %d), Head (%d, %d), Type %d" % info)
	
	spawn_plug(info)


func spawn_plug(info):
	var p = plug.instance()
	
	p.size = Vector2(info[0], info[1])
	p.head_position = Vector2(info[2], info[3])
	
	# set outlet type from data
	if info.size() >= 5:
		p.outlet_type = info[4]
	
	p.original_point = Vector2(0, 0)
	$Node2D/Plugs.add_child(p)
	
	plug_scene.append(p)
	
	# reposition all plugs
	for i in range(plug_scene.size()):
		plug_scene[i].original_point = Vector2(get_viewport().size.x / plug_scene.size() * i - get_viewport().size.x / 2, get_viewport().size.y / 2)


func export_level():
	var x = []
	var y = []
	for i in outlet_scene.values():
		x.append(i.grid_position.x)
		y.append(i.grid_position.y)
	
	if x.size() <= 0 or y.size() <= 0:
		return
	
	current_level.size.append(x.max() + 1)
	current_level.size.append(y.max() + 1)
	
	"""
	for posx in range(x.max()):
		var row = []
		for posy in range(y.max()):
			var key = "%d:%d" % [posx, posy]
			if outlet_scene.has(key):
				row.append()
	"""
	
	for i in outlet_scene.values():
		current_level.outlets.append([i.grid_position.x, i.grid_position.y, i.outlet_type, i.direction])
	
	print(current_level)


func _on_Remove_pressed():
	var itemlist = $"CanvasLayer/Control/PanelContainer/VBoxContainer/ItemList"
	if not itemlist.is_anything_selected():
		return
	
	#if $Node2D/Plugs.get_child_count() > 0:
	#	for i in $Node2D/Plugs.get_children():
	#		i.queue_free()
	
	var removes = Array(itemlist.get_selected_items())
	removes.sort()
	removes.invert()
	print(removes)
	for i in removes:
		current_level.plugs.remove(i)
		itemlist.remove_item(i)
		
		plug_scene[i].cable.queue_free()
		plug_scene[i].queue_free()
		plug_scene.remove(i)


func _on_Export_pressed():
	export_level()
