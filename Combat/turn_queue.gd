extends Node2D

class_name TurnQueue

var active_character

func initialize():
	active_character = get_child(0)
	var battlers = get_battlers()
	for battler in battlers:
		battler.roll_inititive()
	battlers.sort_custom(self, 'sort_order')
	for battler in battlers:
		battler.raise()
	active_character = get_child(0)
	
func sort_order(a : Archetype, b : Archetype) -> bool:
	# compare two character's inititive rolls
	return a.inititive > b.inititive
	
func play_turn():
	await active_character.play_turn(); 'completed'
	var new_idx : int = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_idx)
	
func get_battlers():
	return
