extends Resource


class_name StatF

@export var cap: float = 0 : set = _set_cap
@export var current: float = 0 : set = _set_current

var _cap: float = 0
var _current: float = 0

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
