extends Resource


class_name Item

@export var item_name : String = 'item'

@export var item_description : String = ''
@export var icon : Image = null

@export var effect : Action = null
@export var cooldown : int = 0
@export var values : Dictionary

# {"stat" : value, "stat" : value}
