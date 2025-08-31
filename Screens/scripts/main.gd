extends Node2D


# Called when the node enters the scene tree for the first time.
var current_scene = null

func _ready():
	_change_scene("res://Screens/menu.tscn")

func _change_scene(path):
	if current_scene:
		current_scene.queue_free()
	current_scene = load(path).instantiate()
	add_child(current_scene)
	# Optionally connect a signal to handle switching
	if current_scene.has_signal("screen_requested"):
		current_scene.connect("screen_requested", Callable(self, "_on_screen_requested"))

func _on_screen_requested(fg):
	var path = ''
	if fg == 'battle':
		path = 'res://Screens/battle.tscn'
	elif fg == 'shop':
		path = 'res://Screens/shop.tscn'
	elif fg == 'party':
		path = 'res://Screens/party.tscn'
	elif fg == 'menu':
		path = 'res://Screens/menu.tscn'
	elif fg == 'quit':
		get_tree().quit()
		return
	_change_scene(path)
