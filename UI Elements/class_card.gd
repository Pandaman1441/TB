extends Button

class_name  Class_Card

@export var class_def: Class_Def

signal pick(def: Class_Def)

func _ready() -> void:
	text = class_def.role_name
	
func _pressed() -> void:
	pick.emit(class_def)
