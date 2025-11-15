class_name GameOverMenu

extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManagerSignalBus.game_over_menu_initiated.emit(self)

func set_text(text: String):
	%GameOverHeadline.text = text

func _on_retry_button_pressed():
	GameManagerSignalBus.game_over_menu_quitted.emit()
	GameManagerSignalBus.switch_scene_by_path.emit("res://scenes/game/game.tscn")

func _on_quit_button_pressed():
	GameManagerSignalBus.game_over_menu_quitted.emit()
	GameManagerSignalBus.switch_scene_by_path.emit("res://scenes/main_menu/main_menu.tscn")
