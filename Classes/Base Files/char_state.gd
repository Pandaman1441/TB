extends Resource

class_name Character_State

@export var base_def : String
@export var custom_name : String = ''
@export var level : int = 0
@export var xp : int = 0
@export var learned_skills : Array[Skill]
@export var equiped_skills : Array[Skill]   # cap to 5
@export var current_stats : StartingStats

# items

static func from_def(def: Class_Def, name : String) -> Character_State:
	var st = Character_State.new()
	st.base_def = def.resource_path
	st.custom_name = name
	st.level = 1
	st.xp = 0
	# get base class skill
	return st
