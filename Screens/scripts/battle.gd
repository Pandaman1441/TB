extends Node2D

signal screen_requested(name)
signal battle_ends
signal victory
signal gameover

@onready var turn_queue = $TurnQueue
@onready var hud = $CanvasLayer/BattleHUD
@onready var grid = $Board

var active : bool
var active_battler : Archetype
var battlers : Array[Archetype]

# Called when the node enters the scene tree for the first time.
# we need to pass the party and their formation from game state, then pass an encounter_def that holds the enemies and their formation
func _ready() -> void:
	turn_queue.initialize()
	turn_queue.visible = true
	battlers = turn_queue.battlers
	battle_start()
	

func battle_start():
	active = true
	active_battler = get_active_battler()
	play_turn()
	
func battle_end():
	active = false
	active_battler = get_active_battler()
	active_battler.selected = false
	var player_won : bool = active_battler.party_member
	if player_won:
		emit_signal('victory')
	else:
		emit_signal('gameover')
		# enemy wins
	emit_signal('battle_ends')

func play_turn():
	hud.setup(battlers)
	active_battler = get_active_battler()
	while not active_battler.is_alive():
		turn_queue.skip_turn()
		active_battler = get_active_battler()
	active_battler.selected = true
	var opponents : Array[Archetype] = get_targets()
	var targets : Array[Archetype] = []
	
	if opponents.is_empty():
		battle_end()
		return
	
	if not active_battler.party_member:            # npc turn
		hud.set_turn_state(false, active_battler)  # probably make a call to the archetype and setup their logic in a method
		for t in opponents:                
			if t.is_alive():
				targets.append(t)
		if not targets.is_empty():
			await turn_queue.play_turn(targets, &"basic attack", null)
			
	else:          # player turn
		hud.set_turn_state(true, active_battler)
		await start_player_turn()
		
	active_battler.selected = false
	if active:
		#end_player_turn()
		play_turn()
	
func get_active_battler():
	return turn_queue.active_character
	
func get_targets():
	if get_active_battler().party_member:
		return turn_queue.get_enemies()
	else:
		return turn_queue.get_party()
		
func start_player_turn() -> void:
	var args = await hud.select_action          
	var action: StringName = args[0]
	var data =  args[1]
	var opponents : Array[Archetype] = get_targets()
	var targets : Array[Archetype] = []
	
	for t in opponents:    # auto target selects
			if t.is_alive():
				targets.append(t)
				
	match action:
		&"basic_attack":
			await turn_queue.play_turn(targets, &"basic attack", null)
		&"move":
			turn_queue.skip_turn()
		&"wait":
			turn_queue.skip_turn()
		&"skill":
			var text = '{0} wants to use {1} on {2}'.format([active_battler.c_name, active_battler.skills_defs[data].skill_name, targets[0].c_name])
			print(text)
			await turn_queue.play_turn(targets, &"skill", data)
	
	
func end_player_turn():
	hud.clear_unit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_return_pressed() -> void:
	emit_signal('screen_requested', 'menu')
