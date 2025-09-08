extends Resource

class_name Party_Rules

@export var min_size := 1
@export var max_size := 5
@export var allow_duplicates := false

func can_add(current: Array[Character_State], def: Class_Def) -> bool:
	if current.size() >= max_size:
		return false
	if not allow_duplicates:
		# no duplicates by class id
		for st in current:
			var d: Class_Def = load(st.base_def)
			if d.role_name == def.role_name:
				return false
	return true

func is_valid(current: Array[Character_State]) -> bool:
	return current.size() >= min_size and current.size() <= max_size
