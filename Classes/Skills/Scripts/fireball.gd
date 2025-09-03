extends Deal_Damage


class_name Fireball


func execute(user: Archetype, target: Archetype) -> void:
	var dmg = get_damage(user)
	target.apply_damage(dmg)

	
func get_damage(user: Archetype) -> int:
	var scaling = int(ceil(user.stats.mp.current * .3))
	
	return scaling + base_damage
	
