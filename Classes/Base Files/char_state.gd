extends Resource

class_name Character_State

@export var base_def : String
@export var custom_name : String = ''
@export var level : int = 0
@export var xp : int = 0
@export var learned_skills : Array[Skill]
@export var equiped_skills : Array[Skill]   # cap to 5
@export var current_stats : StartingStats	# quick access to all stats added up
@export var empty_stats : StartingStats		# base stats + stats from current lvl. so we can quickly grab when items change
@export var inventory : Array[Item]
# items
# current stats = base_def.stats + lvl growth + items
# items will probably change more often than lvl

static func from_def(def: Class_Def, name : String) -> Character_State:
	var st = Character_State.new()
	st.base_def = def.resource_path
	st.custom_name = name
	st.level = 1
	st.xp = 0
	st.current_stats = def.base_stats
	st.empty_stats = def.base_stats
	# get base class skill
	return st
	
func calc_stats():
	for i in empty_stats:
		empty_stats.
	pass
