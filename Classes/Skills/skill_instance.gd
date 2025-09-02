extends RefCounted

class_name Skill_Instance

var def: Skill
var current_cooldown: int = 0

func _init(d: Skill) -> void:
	def = d
	
func can_user(user: Archetype) -> bool:
	return user.stats.resource.current >= def.mana_cost and current_cooldown == 0
	
func use(user: Archetype, target: Archetype):
	user.stats.resource.current -= def.mana_cost
	def.effect.execute(user,target)
	current_cooldown = def.cooldown
