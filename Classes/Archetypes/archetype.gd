extends Resource

class_name Archetype

signal died(character)
signal took_damage(character, amount, source)
signal turn_started(character)
signal turn_ended(character)

@export var stats: StartingStats
@export var skills_defs: Array[Skill] = []   

var hp: int
var skills: Array[Skill] = []                  
var actions: Array[Skill] = []  # basic actions like basic attack, move, end turn 
var level: int = 1
var xp = 0
var xp_total = 0
var xp_requirement = get_required_xp(level + 1)

func _ready() -> void:
	pass

func is_alive() -> bool:
	return true
	
func start_turn() -> void:
	pass
	
func end_turn() -> void:
	pass
	
func apply_damage(amount: int, source) -> void:
	pass
	
func get_required_xp(level):
	var value = 5 # do math here
	return value
	
func gain_xp(amount):
	xp_total += amount
	xp += amount
	while xp >= xp_requirement:
		xp -= xp_requirement
		level_up()

func level_up():
	level += 1
	xp_requirement = get_required_xp(level + 1)
	# increase stats based on class here
