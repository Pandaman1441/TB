extends Archetype


class_name Mercenary
# these are for class specific methods or overrides
# most of the functionality should be from the base archetype file

# passive: heal for a percentage of dmg dealt

func _ready() -> void:
	pass

func is_alive() -> bool:
	return true
	
func start_turn() -> void:
	pass
	
func end_turn() -> void:
	pass
	
func apply_damage(amount: int) -> void:
	pass
