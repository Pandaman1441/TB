extends Archetype


class_name Ranger
# these are for class specific methods or overrides
# most of the functionality should be from the base archetype file

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
