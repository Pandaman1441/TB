extends Node2D

signal screen_requested(name)
signal battle_ends
signal victory
signal gameover

@onready var turn_queue = $TurnQueue
@onready var hud = $CanvasLayer/BattleHUD

var active : bool
var active_battler : Archetype
var battlers : Array[Archetype]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_queue.initialize()
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
	if not active_battler.party_member:
		for t in opponents:
			if t.is_alive():
				targets.append(t)
		if not targets.is_empty():
			await turn_queue.play_turn(targets, 'basic attack')
	else:
		await start_player_turn()
		
	active_battler.selected = false
	
	if active:
		end_player_turn()
		play_turn()
	
func get_active_battler():
	return turn_queue.active_character
	
func get_targets():
	if get_active_battler().party_member:
		return turn_queue.get_enemies()
	else:
		return turn_queue.get_party()
		
func start_player_turn() -> void:
	hud.bind_char(active_battler)
	var args = await hud.select_action          
	var action: StringName = args[0]
	var data =  args[1]
	var opponents : Array[Archetype] = get_targets()
	var targets : Array[Archetype] = []
	
	for t in opponents:    # auto target selects
			if t.is_alive():
				targets.append(t)
				
	match action:
		&'basic_attack':
			await turn_queue.play_turn(targets, 'basic attack')
		&'move':
			turn_queue.skip_turn()
		&'wait':
			turn_queue.skip_turn()
		&'skill':
			turn_queue.skip_turn()
	
	
func end_player_turn():
	hud.clear_unit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_return_pressed() -> void:
	emit_signal('screen_requested', 'menu')
