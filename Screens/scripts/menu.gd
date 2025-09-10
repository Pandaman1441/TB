extends Node2D

signal screen_requested(name)
# Called when the node enters the scene tree for the first time.

@onready var selected_box : VBoxContainer = $PartyList
@onready var size : Label = $Label
@onready var grid : Formation_Grid = $FormationGrid
@onready var clear_btn : Button = $Clear
@onready var confirm_btn : Button = $Confirm
var _selection : Array[Character_State] = []
var _selected_idx : int = -1
var _max_party : int = 5
var _current_size : int = 0
var _slots : Array[int] = []


func _ready() -> void:
	if game_state.party.size() > 0:
		_selection = game_state.party.duplicate(true)
	_current_size = game_state.party.size()
	var text = '{0}/{1} Party Members'.format([_current_size, _max_party])
	size.text = text
	_refresh_selected()
	_slots = game_state.formation_slots.duplicate()
	_build_party_buttons()
	_paint_grid()

	# Wire signals
	grid.cell_clicked.connect(_on_cell_clicked)
	clear_btn.pressed.connect(_on_clear_all)
	confirm_btn.pressed.connect(_on_confirm)

func _build_party_buttons() -> void:
	for c in selected_box.get_children():
		c.queue_free()

	for i in game_state.party.size():
		var st := game_state.party[i]
		var b := Button.new()
		b.text = st.custom_name
		b.toggle_mode = true
		b.focus_mode = Control.FOCUS_NONE
		selected_box.add_child(b)

		# Show which slot this member currently occupies
		var pos := _find_party_idx(i)

		b.pressed.connect(func(idx := i, btn := b):
			# toggle selection
			for child in selected_box.get_children():
				(child as Button).button_pressed = false
			btn.button_pressed = true
			_selected_idx = idx)

func _paint_grid() -> void:
	# Update grid cell labels with the occupying member’s name (if any)
	for r in grid.rows:
		for c in grid.cols:
			var who := _slots[r * grid.cols + c]
			var label := ""
			if who >= 0 and who < game_state.party.size():
				label = game_state.party[who].custom_name
			grid.set_cell_text(r, c, label)

func _find_party_idx(pidx: int) -> int:
	# returns slot index (0..8) or -1 if not placed
	return _slots.find(pidx)

func _clear_party_from_slots(pidx: int) -> void:
	var at := _find_party_idx(pidx)
	if at >= 0:
		_slots[at] = -1

func _on_cell_clicked(row: int, col: int) -> void:
	if _selected_idx < 0:
		# If no one selected, clicking an occupied cell unassigns it (optional)
		var i := row * grid.cols + col
		if _slots[i] != -1:
			_slots[i] = -1
			_paint_grid()
		return

	var i := row * grid.cols + col
	var current := _slots[i]

	if current == -1:
		# place selected
		_clear_party_from_slots(_selected_idx)  # ensure uniqueness
		_slots[i] = _selected_idx
	else:
		# occupied: swap the two members (selected ↔ occupant)
		var selected_pos := _find_party_idx(_selected_idx)
		if selected_pos >= 0:
			_slots[selected_pos] = current
			_slots[i] = _selected_idx
		else:
			# selected had no slot; just replace and unassign the prior occupant
			_slots[i] = _selected_idx
			# Remove old occupant from any other place (it won't have one)
			# (no-op because occupant was only here)
		# keep selection on same member if you like
	_paint_grid()

func _on_clear_all() -> void:
	for i in _slots.size():
		_slots[i] = -1
	_paint_grid()

func _on_confirm() -> void:
	# Optionally auto-place any unplaced members to the first empty slots
	for pidx in game_state.party.size():
		if _find_party_idx(pidx) == -1:
			var empty := _slots.find(-1)
			if empty != -1:
				_slots[empty] = pidx

	# Save back to global
	game_state.formation_slots = _slots.duplicate()


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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_battle_button_pressed() -> void:
	emit_signal('screen_requested','battle')

func _on_shop_button_pressed() -> void:
	emit_signal('screen_requested','shop')


func _on_party_button_pressed() -> void:
	emit_signal('screen_requested','party')


func _on_quit_button_pressed() -> void:
	emit_signal('screen_requested','quit')
