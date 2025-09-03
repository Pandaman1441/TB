extends Action


class_name Deal_Damage

@export var base_damage : int
@export var target_range: int
@export var radius: int
@export var target_type: String
@export var position: Vector2
@export var uses_hit_check: bool

func _init() -> void:
	pass

func execute(user: Archetype, target: Archetype) -> void:
	pass

func get_damage(user: Archetype):
	pass 
	
func get_preview(user: Archetype, target: Archetype):
	var out: Dictionary
	if uses_hit_check:
		out['hit_chance'] = Calc_Hc.hit_chance(user,target)
	return out
