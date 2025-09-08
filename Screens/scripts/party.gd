extends Node2D


@export var rules : Party_Rules
@export var roster : Array[Class_Def] = []
@onready var roster_grid : GridContainer = $RosterGrid
@onready var selected_box : HBoxContainer = $SelectedBox
@onready var confirm_button : Button = $Confirm
@onready var name_dialog : Name_Choice = $ConfirmationDialog

var _selection : Array[Character_State] = []
var card_scene = preload('res://UI Elements/ClassCard.tscn')

signal screen_requested(name)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if roster.is_empty() and game_state.roster.size() > 0:
		roster = game_state.roster
	_build_roster()
	if game_state.party.size() > 0:
		_selection = game_state.party.duplicate(true)
	_refresh_selected()
	_update_confirm()
	
		
func _build_roster():
	for child in roster_grid.get_children():
		child.queue_free()
	for def in roster:
		var card : Class_Card = card_scene.instantiate()
		card.class_def = def
		card.pick.connect(_on_pick_class)
		roster_grid.add_child(card)

func _on_pick_class(def : Class_Def):
	if not rules.can_add(_selection, def):
		return
	name_dialog.open(def.display_name)
	name_dialog.submit.connect(func(chosen_name: String):
		var st := Character_State.from_def(def, chosen_name)
		_selection.append(st)
		_refresh_selected()
		_update_confirm(), CONNECT_ONE_SHOT)
	name_dialog.cancelled.connect(func(): pass, CONNECT_ONE_SHOT)
	
	
func _get_name() -> String:
	var name_box = LineEdit.new()
	
	
	return ''
	
func _refresh_selected():
	for i in selected_box.get_child_count():
		var btn = selected_box.get_child(i) as Button
		if i < _selection.size():
			var st = _selection[i]
			var d = load(st.base_def)
			btn.text = st.custom_name
			btn.disabled = false
			if btn.pressed.get_connections().size() > 0:
				btn.pressed.disconnect_all()
			btn.pressed.connect(func(idx = i):
				_selection.remove_at(idx)
				_refresh_selected()
				_update_confirm())
		else:
			btn.text = '(empty)'
			btn.disabled = true
			if btn.pressed.get_connections().size() > 0:
				btn.pressed.disconnect_all()
				
func _update_confirm():
	confirm_button.disabled = not rules.is_valid(_selection)

func _on_confirm_pressed():
	game_state.party = _selection.duplicate(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	emit_signal('screen_requested', 'menu')
