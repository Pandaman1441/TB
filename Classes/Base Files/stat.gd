extends Resource


class_name Stat

@export var cap: int = 0 : set = _set_cap, get = _get_cap
@export var current: int = 0 : set = _set_current, get = _get_current


var _cap: int = 0     # _ these are blockers so it doesn't get stuck in a loop of setting or getting
var _current: int = 0

func _set_cap(value: int) -> void:
	value = max(_cap, value)
	if value == _cap:
		return
	_cap = value
	if _current > _cap:
		_current = _cap
	_current = min(_current, _cap)
	#changed.emit()

func _set_current(value: int) -> void:
	value = clamp(value, 0, _cap)
	if value == _current:
		return
	_current = value
	#changed.emit()
	

func _get_cap() -> int:
	return _cap
	
func _get_current() -> int:
	return _current

func add_value(value: int):
	var perc : float
	perc = float(current) / float(cap)
	cap += value
	current = ceil(float(cap) * perc)

func sub_value(value: int):
	var perc : float
	perc = float(current) / float(cap)
	cap -= value
	current = ceil(float(cap) * perc)
