extends Action


class_name Deal_Damage

@export var damage : int
@export var range: int
@export var radius: int
@export var target_type: String
@export var position: Vector2

func execute(user, target) -> void:
	user
