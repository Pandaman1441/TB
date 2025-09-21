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
@onready var foe_info : VBoxContainer = $Panel/EnemyInfo

var active : Archetype = null
var _interactive : bool = false

func _ready() -> void:
	attack_btn.pressed.connect(func(): emit_signal('select_action', &'basic_attack', null))
	move_btn.pressed.connect(func(): emit_signal('select_action', &'move', null))
	wait_btn.pressed.connect(func(): emit_signal('select_action', &'wait', null))
	_set_enabled(false)
	
	
func bind_char(c : Archetype) -> void:
	if active == c:
		refresh()
		return
	_disconnect_signals()
	active = c
	_connect_signals()
	refresh()
	
func set_turn_state(player: bool, c: Archetype):
	if c and c.party_member == 0:
		bind_char(c)
		_set_enabled(true)
	else:
		_set_enabled(false)
	
func clear_unit():
	_clear_skills()
	active = null
	name_label.text = ''
	mana_label.text = ''
	hp_label.text = ''
	attack_btn.visible = false
	move_btn.visible = false
	wait_btn.visible = false
	
func setup(battlers: Array[Archetype]):
	for c in foe_info.get_children():
		c.queue_free()

	for i in battlers:
		if i.party_member == 1:
			var l = Label.new()
			l.text = "{0} HP: {1}".format([i.c_name, i.stats.hp.current])
			foe_info.add_child(l)
	
func refresh():
	if active == null:
		return
	name_label.text = active.c_name
	hp_label.text = "HP: %d / %d" % [active.stats.hp.current, active.stats.hp.cap]
	mana_label.text = "Mana: %d / %d" % [active.stats.resource.current, active.stats.resource.cap]
	attack_btn.visible = true
	move_btn.visible = true
	wait_btn.visible = true
	
	_rebuild_skills()
	
func _rebuild_skills():
	_clear_skills()
	if active and active.skills_defs:
		for i in active.skills_defs.size():
			var s: Skill = active.skills_defs[i]
			var b := Button.new()
			b.text = s.skill_name
			b.tooltip_text = s.skill_description
			b.pressed.connect(func(idx:=i): 
				emit_signal('select_action', &'skill', idx))
			skills_box.add_child(b)
			

func _clear_skills():
	for c in skills_box.get_children():
		c.queue_free()
	
func _set_enabled(enabled: bool):
	_interactive = enabled
	attack_btn.disabled = not enabled
	move_btn.disabled = not enabled
	wait_btn.disabled = not enabled
	for c in skills_box.get_children():
		c.disabled = not enabled
	if enabled:
		$Panel/Info.modulate.a = 1
	else:
		$Panel/Info.modulate.a = 0.5

func _connect_signals(): 
	if active == null:
		return
	if active.has_signal('took_damage'):
		active.took_damage.connect(refresh, CONNECT_DEFERRED)

func _disconnect_signals():
	if active == null:
		return
	if active.has_signal('took_damage') and active.took_damage.is_connected(refresh):
		active.took_damage.disconnect(refresh)
