extends Node2D

func _unhandled_key_input(event):
	if event.is_pressed():
		GameManagerSignalBus.switch_scene_by_path.emit("res://scenes/game/game.tscn")
