extends Node

var console
var grid

var current_level = 1
var current_level_data setget ,level_data_get


func level_data_get():
	return Global.console.level[Global.current_level]
