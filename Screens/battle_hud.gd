extends Control


class_name BattleHUD

signal select_action(action: String, idx: int)

@onready var name_label : Label = $Panel/Info/CharName
@onready var hp_label : Label = $Panel/Info/Resources/HP
@onready var mana_label : Label = $Panel/Info/Resources/Mana
@onready var attack_btn : Button = $Panel/Info/BasicActions/BasicAttack
@onready var move_btn : Button = $Panel/Info/BasicActions/Move
@onready var wait_btn : Button = $Panel/Info/BasicActions/Wait
@onready var skills_box : HBoxContainer = $Panel/Info/Skills

var active : Archetype = null

func _ready() -> void:
	attack_btn.pressed.connect(func(): emit_signal('select_action', &'basic_attack', null))
	move_btn.pressed.connect(func(): emit_signal('select_action', &'move', null))
	wait_btn.pressed.connect(func(): emit_signal('select_action', &'wait', null))
	
func bind_char(c : Archetype) -> void:
	active = c
	_refresh()
	
func clear_unit():
	_clear_skills()
	active = null
	name_label.text = ''
	mana_label.text = ''
	hp_label.text = ''
	
func _refresh():
	if active == null:
		return
	name_label.text = active.c_name
	hp_label.text = "HP: %d" % active.stats.hp.current
	mana_label.text = "Mana: %d" % active.stats.resource.current
	
	_clear_skills()
	if 'skills_defs' in active and active.skills_defs:
		for i in active.skills_defs.size():
			var s: Skill = active.skills_defs[i]
			var b := Button.new()
			b.text = s.skill_name
			b.tooltip_text = s.skill_description
			b.pressed.connect(func(idx:=i): emit_signal('select_action', &'skill', idx))
			skills_box.add_child(b)

func _clear_skills():
	for c in skills_box.get_children():
		c.queue_free()
	
func _set_enabled(enabled: bool):
	pass
