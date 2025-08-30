extends Archetype


class_name Paladin
# these are for class specific methods or overrides
# most of the functionality should be from the base archetype file

# passive: taking or dealing dmg, buffs heals. heals buff dmg

func _ready() -> void:
	pass

func is_alive() -> bool:
	return true
	
func start_turn() -> void:
	pass
	
func end_turn() -> void:
	pass
	
func apply_damage(amount: int, source) -> void:
	pass
