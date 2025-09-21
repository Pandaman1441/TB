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
			
	setup(game_state.formation_slots,0)
	
func assign_location(marker : Marker2D, parts : Array[String]):
	var cell := Vector3i(int(parts[0]),int(parts[1]),int(parts[2]))
	#var text = '{0} : {1}'.format([cell, marker.global_position])
	#var s_cell = '{0}'.format([cell])
	#print(text)
	#var l := Label.new()
	#l.text = String(s_cell)
	#l.global_position = marker.global_position
	#markers_location.add_child(l)
	layout[cell] = marker.global_position
	
func _reset():
	occupancy.clear()
	layout.clear()
	lookup.clear()
	
func setup(formation : Array[int], side : int):			# setup one side based on a formation
	if side == 0:
		for i in game_state.party.size():
			var pos = game_state.pos_for_party_index(i)
			var actor := combat.build_actor_from_state(game_state.party[i])
			place_actor(side,pos.x,pos.y, actor)
	
func place_actor(side:int, row:int, col:int, actor:Archetype):		# place a single character on the board
	occupancy[side][row][col] = actor
	lookup[actor] = Vector3i(side,row,col)
	actor.global_position = layout[Vector3i(side,row,col)]
	
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

	
