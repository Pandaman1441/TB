extends Node

class_name GameState

var party : Array[Character_State] = []
var gold : int = 0
var inventory : Array[int] = []

# this file holds what carries over between scenes
var roster : Array[Class_Def] = []

const class_defs_dir = 'res://Classes/Base Classes'
func _ready() -> void:
	roster.clear()
	var dir = DirAccess.open(class_defs_dir)
	if dir:
		for f in dir.get_files():
			if f.ends_with('.tres'):
				var def = load(class_defs_dir + "/" + f)
				if def is Class_Def:
					roster.append(def)
