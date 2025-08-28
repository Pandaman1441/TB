extends Node2D

class_name TurnQueue

var active_character

func initialize():
	active_character = get_child(0)
	var battlers = get_battlers()
	battlers.sort_custom(self, 'sort_order')
	for battler in battlers:
		battler.raise()
	active_character = get_child(0)
	
func sort_order(a : Battler, b : Battler) -> bool:
	# compare two character's inititive rolls
	return a.stats.inititive > b.stats.inititive
	
func play_turn():
	await active_character.play_turn(); 'completed'
	var new_idx : int = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_idx)
	
func get_battlers():
	return
