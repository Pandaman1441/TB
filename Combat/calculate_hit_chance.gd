extends Node

class_name hit_chance

# clamp bounds so nothing is 0%/100% 
const MIN_HIT = 5
const MAX_HIT = 95

# acc_mod/eva_mod let actions tweak the formula (weapon traits, buffs, etc.)
func hit_chance(user, target) -> int:
	var acc = float(user.stats.accuracy.current)
	var ag = target.stats.ag.current
	var d = float(ag * .70) / float(ag + 80)
	var pct = acc - d 
	
	return int(clamp(round(pct), MIN_HIT, MAX_HIT))

func roll_hit(pct: int) -> bool:
	var roll = randi_range(1, 100)
	return roll <= pct
	# true is a success

func build_actor_from_state(st: Character_State) -> Archetype:
	var def : Class_Def = load(st.base_def)
	var actor : Archetype = def.role.instantiate()
	actor.setup(st.custom_name,st.current_stats, st.equiped_skills)
	return actor
