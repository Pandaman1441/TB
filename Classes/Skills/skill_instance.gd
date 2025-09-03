extends RefCounted

class_name Skill_Instance

var def: Skill
var current_cooldown: int = 0

func _init(d: Skill) -> void:
	def = d
	
func can_use(user: Archetype) -> bool:
	return user.stats.resource.current >= def.mana_cost and current_cooldown == 0
	
func execute(user: Archetype, target: Archetype):
	print('in skill instance')
	print(target.stats.hp.current)
	print(user.stats.resource.current)
	
	user.stats.resource.current -= def.mana_cost
	await def.effect.execute(user, target)
	current_cooldown = def.cooldown
	print(target.stats.hp.current)
	print(user.stats.resource.current)
	
