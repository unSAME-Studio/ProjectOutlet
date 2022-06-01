extends Node

const GRID_SIZE = 200
var plug = preload("res://objects/Plug.tscn")
var outlet = preload("res://objects/Outlet.tscn")
export (ButtonGroup) var outlet_options

var current_level = {
	"outlets": [],
	"size": [],
	"plugs": [],
	"completed": "false"
}
var additional_outlets = [
	
]
var plug_scene = [
	
]
var outlet_scene = {
	
}

var plug_start_position = Vector2.ZERO


func _ready():
	Global.main = self
	
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("One")
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("TWO")
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type.add_item("ALL")

	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer3/Type.add_item("One")
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer3/Type.add_item("TWO")
	$CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer3/Type.add_item("ALL")
	
	$"Node2D/TileMap/Line2D".set_default_color(ColorManager.color.main)
	$"Node2D/TileMap/Line2D2".set_default_color(ColorManager.color.main)
	$Node2D/TileMap.set_modulate(ColorManager.color.second)
	$Node2D/TileMap.modulate.a = 0.3


func game_finished():
	pass


func _unhandled_input(event):
	# go back to menu
	if Input.is_action_just_pressed("editor"):
		TransitionManager.play_out("res://scenes/Menu.tscn")
	
	if $"CanvasLayer/Control/PanelContainer2/HBoxContainer3/PlayMode".is_pressed():
		
		if Input.is_action_just_pressed("click"):
			var position = $Node2D/TileMap.world_to_map($Node2D/TileMap.to_local($Node2D.get_global_mouse_position()))
			var key = "%d:%d" % [position.x, position.y]
			
			# check if key out of range
			if position.x < 0 or position.y < 0:
				return
			
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
				outlet_scene[key].call_deferred("queue_free")
				outlet_scene.erase(key)
				return
	
	else:
		# drawing plug
		if Input.is_action_just_pressed("click"):
			var position = $Node2D/TileMap.world_to_map($Node2D/TileMap.to_local($Node2D.get_global_mouse_position()))
			var key = "%d:%d" % [position.x, position.y]
			
			plug_start_position = position
			
		if Input.is_action_just_released("click"):
			var position = $Node2D/TileMap.world_to_map($Node2D/TileMap.to_local($Node2D.get_global_mouse_position()))
			var size = (position - plug_start_position).abs() + Vector2.ONE
			
			var info = [
				size.x,
				size.y,
				0,
				0,
				0,
				[]
			]
			
			current_level.plugs.append(info)
			$"CanvasLayer/Control/PanelContainer/VBoxContainer/ItemList".add_item("Size (%d, %d), Head (%d, %d), Type %d, Outlet: %s" % info)
			
			var p = spawn_plug(info)
			p.original_point = $Node2D/TileMap.map_to_world(plug_start_position) + (Vector2(GRID_SIZE, GRID_SIZE) / 2)
	
	
	if Input.is_action_pressed("camera"):
		$Node2D/Camera2D.set_global_position(lerp($Node2D/Camera2D.get_global_position(), $Node2D.get_global_mouse_position(), 0.1))
	
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_UP:
					$Node2D/Camera2D.set_zoom($Node2D/Camera2D.get_zoom() + Vector2(0.2, 0.2))
				BUTTON_WHEEL_DOWN:
					$Node2D/Camera2D.set_zoom($Node2D/Camera2D.get_zoom() - Vector2(0.2, 0.2))


func _on_SpawnPlug_pressed():
	var info = [
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Sizex".get_line_edit().get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Sizey".get_line_edit().get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Headx".get_line_edit().get_text()),
	int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Heady".get_line_edit().get_text()),
	$"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/Type".get_selected(),
	additional_outlets.duplicate(true),
	]
	
	current_level.plugs.append(info)
	
	$"CanvasLayer/Control/PanelContainer/VBoxContainer/ItemList".add_item("Size (%d, %d), Head (%d, %d), Type %d, Outlet: %s" % info)
	
	spawn_plug(info)
	
	# clear additional outlets
	#additional_outlets.clear()
	#$CanvasLayer/Control/PanelContainer/VBoxContainer/OutletList.clear()
		
	# reposition all plugs
	for i in range(plug_scene.size()):
		plug_scene[i].original_point = Vector2($Node2D.get_viewport_rect().size.x / plug_scene.size() * i - $Node2D.get_viewport_rect().size.x / 2, $Node2D.get_viewport_rect().size.y / 2)


func spawn_plug(info):
	var p = plug.instance()
	
	p.size = Vector2(info[0], info[1])
	p.head_position = Vector2(info[2], info[3])
	
	# set outlet type from data
	if info.size() >= 5:
		p.outlet_type = info[4]
	
	# if additional outlet exist TEMP IMPLEMENT
	if info.size() >= 6:
		print(info[5])
		for add in info[5]:
			p.additional_outlets.append(add)
	
	p.original_point = Vector2(0, 0)
	$Node2D/Plugs.add_child(p)
	
	plug_scene.append(p)
	
	return p


func export_level():
	# calculate Level Size
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
	
	var new_level = String(current_level)
	new_level.replace("outlets", "\"outlets\"")
	new_level.replace("plugs", "\"plugs\"")
	new_level.replace("size", "\"size\"")
	print(new_level + ",")


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
		Global.console.avaliable_plugs.erase(plug_scene[i])
		Global.console.attached_plugs.erase(plug_scene[i])
		Global.hover_plugs.erase(plug_scene[i])
		plug_scene[i].call_deferred("queue_free")
		plug_scene.remove(i)


func _on_Export_pressed():
	export_level()


func _on_PlugsMenu_toggled(button_pressed):
	if button_pressed:
		$"CanvasLayer/Control/PanelContainer".show()
	else:
		$"CanvasLayer/Control/PanelContainer".hide()



func _on_AddOutlet_pressed():
	var new_outlet = [
		int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer3/Headx".get_line_edit().get_text()),
		int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer3/Heady".get_line_edit().get_text()),
		int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer3/Type".get_selected()),
		int($"CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer3/Rot".get_line_edit().get_text()),
	]
	
	additional_outlets.append(new_outlet)
	
	$CanvasLayer/Control/PanelContainer/VBoxContainer/OutletList.add_item(String(new_outlet))


func _on_RemoveOutlet_pressed():
	var outletlist = $"CanvasLayer/Control/PanelContainer/VBoxContainer/OutletList"
	if not outletlist.is_anything_selected():
		return
	
	var removes = Array(outletlist.get_selected_items())
	removes.sort()
	removes.invert()
	for i in removes:
		additional_outlets.remove(i)
		outletlist.remove_item(i)
