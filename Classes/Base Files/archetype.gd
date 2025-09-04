extends Node2D

class_name Archetype

signal died(character)
signal took_damage(character, amount)
signal turn_started(character)
signal turn_ended(character)

@export var stats: StartingStats
@export var skills_defs: Array[Skill] = []   # holds skill definitions, don't use to activate skill
@export var party_member: bool = false
@export var inititive: int = 0
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@export var c_name: String = ''


var skill_states: Array[Skill_Instance] = []                  

var level: int = 1
var xp = 0
var xp_total = 0
var xp_requirement = get_required_xp(level + 1)
var selected : bool = false


func initialize() -> void:
	stats = stats.duplicate(true)
	stats.hp.current = stats.hp.cap
	stats.resource.current = stats.resource.cap
	animations.play('idle')
	if not party_member:
		animations.flip_h = true
	for def in skills_defs:
		skill_states.append(Skill_Instance.new(def))
	


func is_alive() -> bool:
	return stats.hp.current > 0
	
func play_turn(target: Array[Archetype], action, data):
	emit_signal('turn_started', self)
	#ap = 2
	match action:
		&"basic attack":
			basic_attack(target[0])
		&"move":
			pass
		&"wait":
			pass
		&"skill":
			var s : Skill_Instance = skill_states[data]
			if s.can_use(self):
				await s.execute(self, target[0])
	#action.execute(self, target)
	await get_tree().create_timer(1.0).timeout
	
func end_turn() -> void:
	#ap = 0
	emit_signal('turn_ended', self)
	
func roll_inititive() -> void:
	var i = 0
	i = ceil(stats.ag.current * 0.25) + 75
	inititive = randi_range(0, i+1)
	
func apply_damage(amount: int) -> void:
	emit_signal('took_damage', self, amount)
	var text = '{0} took {1} dmg'.format([c_name, amount])
	print(text)
	stats.hp.current = max(stats.hp.current - amount, 0)
	if stats.hp.current <= 0:
		emit_signal('died', self)
	
func get_required_xp(next_level: int):
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
	var pct = Calc_Hc.hit_chance(self, target)
	if Calc_Hc.roll_hit(pct):
		#var text = '{0} attacks {1} for {2}'.format([c_name, target.c_name, stats.pp.current])
		#print(text)
		animations.position = Vector2(40,0)
		animations.play('attack')
		await animations.animation_finished
		target.apply_damage(stats.pp.current)
	animations.play('idle')
		
func move():
	pass
	
func wait():
	pass
