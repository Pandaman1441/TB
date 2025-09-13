extends Node


class_name Board

# layout (dictionary or array of arrays) need to point each cell at a specific place on the screen so we can quickly move a unit to that marker
# occupancy (array of arrays) this is the logic grid, 3x3 each space holds either null or an archetype 'reference'
# lookup (dictionary) characters are paired to a cell for quickly getting where a character is, artificer : (A, 0, 2), artificer is at ally side, first row third column

# 0 = ally, 1 = enemy
# vector3i; (x,y,z)

@onready var markers_location = $Markers
var layout : Dictionary = {}		# layout[parts] = global position
var occupancy : Array = []   # [0][1][2]  0 = ally, 1 = first row, 2 = second column, returns an archetype or null
var lookup : Dictionary = {}		# lookup[archetype] = vector3i


func _ready() -> void:
	_reset()
	occupancy.resize(2)
	for s in range(2):
		var side_rows := []
		for r in range(3):
			var row_cols := []
			for c in range(3):
				row_cols.append(null)
			side_rows.append(row_cols)
		occupancy[s] = side_rows
		
	for m in markers_location.get_children():
		if m is Marker2D:
			var parts := m.name.split("_")
			assign_location(m, parts)
			
func assign_location(marker : Marker2D, parts : Array[String]):
	var cell := Vector3i(int(parts[0]),int(parts[1]),int(parts[2]))
	layout[cell] = marker.global_position
	
func _reset():
	occupancy.clear()
	layout.clear()
	lookup.clear()
	
func setup():			# setup one side based on a formation
	pass
	
func place_actor():		# place a single character on the board
	pass
	
func move_actor():		# change lookup table and occupancy
	pass
	
func get_cell_of():		# return vector3I
	pass
	
func get_actor_at():	# return archetype
	pass
	
func is_empty():		# return bool
	pass
	
func reachable_cells():	# return array of vector3i
	pass

	
