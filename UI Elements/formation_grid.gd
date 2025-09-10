extends Control


class_name Formation_Grid

signal cell_clicked(row: int, col: int)

@export var rows : int = 3
@export var cols : int = 3
@export var cell_size : Vector2 = Vector2(96,96)
@export var cell_gap : Vector2 = Vector2(8,8)

var _buttons : Array[Button] = []

func _ready() -> void:
	_build_cells()

func _build_cells() -> void:
	# Clear old
	for c in get_children():
		c.queue_free()
	_buttons.clear()

	# Size the Control to fit the grid (optional)
	var step := cell_size + cell_gap
	custom_minimum_size = Vector2(cols * step.x - cell_gap.x, rows * step.y - cell_gap.y)

	# Spawn a Button per cell
	for r in rows:
		for c in cols:
			var btn := Button.new()
			btn.focus_mode = Control.FOCUS_NONE
			btn.custom_minimum_size = cell_size
			btn.size = cell_size
			btn.position = Vector2(c * step.x, r * step.y)
			btn.text = ""     # we’ll set names from outside
			add_child(btn)
			_buttons.append(btn)

			btn.pressed.connect(func(rr := r, cc := c): cell_clicked.emit(rr, cc))

func set_cell_text(row: int, col: int, txt: String) -> void:
	var i := row * cols + col
	if i >= 0 and i < _buttons.size():
		_buttons[i].text = txt

func highlight_cells(cells: Array[Vector2i], on := true) -> void:
	# Optional: visually mark allowed cells (change Button modulate or add a StyleBox)
	var mark : int 
	if on: 
		mark = 0.25 
	else: 0.0
	for i in _buttons.size():
		_buttons[i].modulate.a = 0.0
	for v in cells:
		var idx := v.x * cols + v.y
		if idx >= 0 and idx < _buttons.size():
			_buttons[idx].modulate.a = mark
