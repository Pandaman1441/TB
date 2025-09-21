extends Node2D

class_name TurnQueue

var active_character : Archetype
var battlers : Array[Archetype] = []
var idx : int

func initialize() -> void:
	battlers.clear()
	get_battlers()
	for battler in battlers:
		battler.initialize()
		battler.roll_inititive()
	battlers.sort_custom(sort_order)
	idx = 0
	active_character = battlers[idx]
	
	# print turn order
	#for battler in  battlers:
		#var text = '{0}: {1}'.format([battler.c_name, battler.inititive])
		#print(text)
		
func sort_order(a : Archetype, b : Archetype) -> bool:
	# compare two character's inititive rolls
	return a.inititive > b.inititive
	
func play_turn(target : Array[Archetype], action:String, data):
	await active_character.play_turn(target,action, data)
	idx = (idx + 1) % battlers.size()
	active_character = battlers[idx]
	
func get_battlers():
	for c in get_children():
		battlers.append(c)
	

func get_party():
	var t : Array[Archetype] = []
	for b in battlers:
		if b.party_member == 0:
			t.append(b)
	return t
	
func get_enemies():
	var t : Array[Archetype] = []
	for b in battlers:
		if b.party_member == 1:
			t.append(b)
	return t

func skip_turn():
	idx = (idx + 1) % battlers.size()
	active_character = battlers[idx]
	
func next_battler():
	idx = (idx + 1) % battlers.size()
	return battlers[idx]
	
func get_targets():
	if active_character.party_member == 0:
		return get_enemies()
	else:
		return get_party()
