extends Node2D

var game_path: String = "res://scenes/game/game.tscn"
var was_pressed: bool = false

func _ready() -> void:
	ResourceLoader.load_threaded_request(game_path)

func _process(_delta) -> void:
	if was_pressed && ResourceLoader.has_cached(game_path):
		GameManagerSignalBus.switch_scene_by_resource.emit(ResourceLoader.load_threaded_get(game_path))

func _unhandled_key_input(event):
	if event.is_pressed():
		was_pressed = true
