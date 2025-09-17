extends Node

class_name GameState

var party : Array[Character_State] = []
var gold : int = 0
var inventory : Array[int] = []

# this file holds what carries over between scenes
var roster : Array[Class_Def] = []
var grid_size : int = 3
var formation_slots : Array[int] = []


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
	if formation_slots.is_empty():
		set_default_formation()

func set_default_formation() -> void:
	formation_slots.resize(grid_size * grid_size)
	for i in formation_slots.size():
		formation_slots[i] = -1
	# Auto-place current party left->right, top->bottom
	var k := 0
	for i in party.size():
		if k >= formation_slots.size(): break
		formation_slots[k] = i
		k += 1

func slot_index(row: int, col: int) -> int:
	return row * grid_size + col

func pos_for_party_index(pidx: int) -> Vector2i:
	# returns (-1,-1) if not placed
	for i in formation_slots.size():
		if formation_slots[i] == pidx:
			return Vector2i(i / grid_size, i % grid_size)
	return Vector2i(-1, -1)
