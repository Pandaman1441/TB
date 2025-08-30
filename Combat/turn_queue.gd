extends Node

class_name TurnQueue

var active_character: Archetype
var battlers: Array[Archetype] = []

func initialize(grid: Node) -> void:
	# get all Archetype nodes that are children (or use groups)
	battlers = get_tree().get_nodes_in_group("battler")
	battlers.sort_custom(self, "_sort_order")
	active_character = battlers[0]

func _sort_order(a: Archetype, b: Archetype) -> bool:
	return a.stats.ag.cap > b.stats.ag.cap  # sort by AG (speed)

func play_turn(grid: Node) -> void:
	await active_character.start_turn()
	# simple AI: attack if enemy adjacent else move towards nearest enemy then wait
	var enemy := _get_nearest_enemy(active_character, grid)
	if enemy and active_character.can_basic_attack(enemy, grid):
		active_character.basic_attack(enemy, grid)
	elif enemy:
		var step := _get_step_toward(active_character, enemy, grid)
		if step: active_character.move_to(step, grid)
	active_character.wait()
	active_character.end_turn()
	var idx := (battlers.find(active_character) + 1) % battlers.size()
	active_character = battlers[idx]

func _get_nearest_enemy(unit: Archetype, grid) -> Archetype:
	# naive: find first enemy in list
	for b in battlers:
		if b.team != unit.team and b.is_alive():
			return b
	return null

func _get_step_toward(unit: Archetype, target: Archetype, grid) -> Vector2i:
	# naive: move horizontally then vertically
	var cell := grid.world_to_cell(unit.position)
	var goal := grid.world_to_cell(target.position)
	var dx := signi(goal.x - cell.x)
	var dy := signi(goal.y - cell.y)
	var next := cell + Vector2i(dx, 0)
	if grid.is_reachable(unit, next, 1): return next
	next = cell + Vector2i(0, dy)
	return grid.is_reachable(unit, next, 1) ? next : null
