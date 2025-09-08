extends ConfirmationDialog

class_name Name_Choice

@export var min_len := 1
@export var max_len := 16
@export var placeholder : String

signal submit(name: String)
signal cancelled

@onready var input: LineEdit = $name_input


func _ready() -> void:
	title = "Name Your Character"
	ok_button_text = "Confirm"
	get_ok_button().disabled = false
	
	input.text_changed.connect(_on_text_changed)
	input.text_submitted.connect(func(_t): _try_confirm())
	
	confirmed.connect(_on_confirmed)           
	if has_signal(&"canceled"):               
		canceled.connect(func(): cancelled.emit())
	close_requested.connect(func(): cancelled.emit())

func open(default_text := "") -> void:
	input.text = default_text
	_on_text_changed(input.text)
	popup_centered()
	await get_tree().process_frame
	input.grab_focus()
	input.select_all()

func _on_text_changed(_t: String) -> void:
	var t := input.text.strip_edges()
	var msg := ""
	if t.length() < min_len:
		msg = "Name must be at least %d characters." % min_len
	elif t.length() > max_len:
		msg = "Name must be at most %d characters." % max_len

	get_ok_button().disabled = (msg != "")

func _try_confirm() -> void:
	if not get_ok_button().disabled:
		_on_confirmed()

func _on_confirmed() -> void:
	submit.emit(input.text.strip_edges())
