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


func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_pressed)
	if roster.is_empty() and game_state.roster.size() > 0:
		roster = game_state.roster

	_build_roster()
	_wire_slot_buttons_once()  

	if game_state.party.size() > 0:
		_selection = game_state.party.duplicate(true)

	_refresh_selected()
	_update_confirm()

func _build_roster() -> void:
	for child in roster_grid.get_children():
		child.queue_free()

	for def in roster:
		var card: Class_Card = card_scene.instantiate()
		card.class_def = def
		card.pick.connect(_on_pick_class)
		roster_grid.add_child(card)

func _wire_slot_buttons_once() -> void:
	for i in selected_box.get_child_count():
		var btn := selected_box.get_child(i) as Button
		if btn == null:
			continue
		btn.set_meta("slot_index", i)
		if not btn.pressed.is_connected(_on_slot_pressed):
			btn.pressed.connect(_on_slot_pressed.bind(btn))

func _on_pick_class(def: Class_Def) -> void:
	if not rules.can_add(_selection, def):
		return

	name_dialog.open(def.display_name)

	name_dialog.submit.connect(func(chosen_name: String):
		var st := Character_State.from_def(def, chosen_name)
		_selection.append(st)
		_refresh_selected()
		_update_confirm(), CONNECT_ONE_SHOT)

	name_dialog.cancelled.connect(func(): pass, CONNECT_ONE_SHOT)

func _refresh_selected() -> void:
	for i in selected_box.get_child_count():
		var btn := selected_box.get_child(i) as Button
		if btn == null:
			continue

		btn.set_meta("slot_index", i) 

		if i < _selection.size():
			var st := _selection[i]
			btn.text = st.custom_name
			btn.disabled = false
		else:
			btn.text = "(empty)"
			btn.disabled = true

func _on_slot_pressed(btn: Button) -> void:
	var idx := int(btn.get_meta("slot_index"))
	if idx >= 0 and idx < _selection.size():
		_selection.remove_at(idx)
		_refresh_selected()
		_update_confirm()

func _update_confirm() -> void:
	confirm_button.disabled = not rules.is_valid(_selection)

func _on_confirm_pressed() -> void:
	game_state.party = _selection.duplicate(true)
	print(game_state, game_state.get_path())

func _on_return_pressed() -> void:
	emit_signal("screen_requested", "menu")
