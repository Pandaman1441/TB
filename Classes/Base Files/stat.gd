extends Resource


class_name Stat

@export var cap: int = 0 : set = _set_cap, get = _get_cap
@export var current: int = 0 : set = _set_current, get = _get_current

var _cap: int = 0     # _ these are blockers so it doesn't get stuck in a loop of setting or getting
var _current: int = 0

func _set_cap(value: int) -> void:
	_cap = value
	_current = min(_current, _cap)

func _set_current(value: int) -> void:
	_current = clamp(value, 0, _cap)

func _get_cap() -> int:
	return _cap
	
func _get_current() -> int:
	return _current
