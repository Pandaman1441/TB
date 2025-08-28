extends Node2D

class_name Archetype

signal died(character)
signal took_damage(character, amount, source)
signal turn_started(character)
signal turn_ended(character)

@export var display_name: String = "Unit"
@export var team: int = 0
@export var stats: StartingStats
@export var skills_defs: Array[Skill] = []   

var hp: int
var mp: int
var ap: int = 0
var skills: Array[Skill] = []                  
var actions: Array[Skill] = []  # basic actions like basic attack, move, end turn 

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
	
