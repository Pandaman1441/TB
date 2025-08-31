extends Resource


class_name StatF

@export var cap: float = 0 : set = _set_cap
@export var current: float = 0 : set = _set_current

var _cap: float = 0
var _current: float = 0

func _set_cap(value: float) -> void:
	_cap = value
	_current = min(_current, _cap)

func _set_current(value: float) -> void:
	_current = clamp(value, 0, _cap)
