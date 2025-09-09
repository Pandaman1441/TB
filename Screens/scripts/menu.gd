extends Node2D

signal screen_requested(name)
# Called when the node enters the scene tree for the first time.


	
	
func _ready() -> void:
	print(game_state.party.size())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_battle_button_pressed() -> void:
	emit_signal('screen_requested','battle')

func _on_shop_button_pressed() -> void:
	emit_signal('screen_requested','shop')


func _on_party_button_pressed() -> void:
	emit_signal('screen_requested','party')


func _on_quit_button_pressed() -> void:
	emit_signal('screen_requested','quit')
