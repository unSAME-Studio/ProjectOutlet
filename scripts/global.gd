extends Node

var console
var grid
var main

var current_level = 1
var current_level_data setget ,level_data_get


func _ready():
	pass


func level_data_get():
	return Global.console.level[Global.current_level]


func load_database(file_name: String):
	var data_file = File.new()
	data_file.open("res://%s.json" % file_name, File.READ)
	
	var database = parse_json(data_file.get_as_text())
	
	data_file.close()
	
	return database
