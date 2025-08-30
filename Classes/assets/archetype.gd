extends Node2D

class_name Archetype

signal died(character)
signal took_damage(character, amount)
signal turn_started(character)
signal turn_ended(character)

@export var stats: StartingStats
@export var skills_defs: Array[Skill] = []   
@export var team: int = 0 # 0 = player, 1 = npc
@export var inititive: int = 0


var hp: int 
var skill_states: Array[Skill_Instance] = []                  

var level: int = 1
var xp = 0
var xp_total = 0
var xp_requirement = get_required_xp(level + 1)
var ap: int

func _ready() -> void:
	hp = stats.hp.current
	ap = 0
	for def in skills_defs:
		skill_states.append(Skill_Instance.new(def))

func is_alive() -> bool:
	return hp > 0
	
func start_turn(target: Archetype, action) -> void:
	emit_signal('turn_started', self)
	ap = 2
	action.execute(self, target)
	await get_tree().create_timer(1.0); 'timeout'
	
func end_turn() -> void:
	ap = 0
	emit_signal('turn_ended', self)
	
func roll_inititive() -> void:
	var i = 0
	i = ceil(stats.ag.current * 0.25) + 75
	inititive = randi_range(0, i+1)
	
func apply_damage(amount: int) -> void:
	emit_signal('took_damage', self, amount)
	hp = max(hp - amount, 0)
	if hp <= 0:
		emit_signal('died', self)
	
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
	
	
# basic actions; basic attack, move, wait
# classes have their own scaling so override basic attack and maybe some move more spaces

func basic_attack(target: Archetype):
	pass

func move():
	pass
	
func wait():
	pass
