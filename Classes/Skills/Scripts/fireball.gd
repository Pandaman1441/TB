extends Deal_Damage


class_name Fireball


func execute(user: Archetype, target: Archetype) -> void:
	print('in fireball')
	print(target)
	var dmg = get_damage(user)
	print(dmg)
	target.apply_damage(dmg)
	print('hello')
	await target.apply_damage(user.stats.pp.current)

	
func get_damage(user: Archetype) -> int:
	var scaling = int(ceil(user.stats.mp.current * .3))
	
	return scaling + base_damage
	
