class_name PauseMenu

extends Control

func _ready():
	GameManagerSignalBus.pause_menu_initiated.emit(self)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_resume_button_pressed():
	GameManagerSignalBus.pause_requested.emit()

func _on_quit_button_pressed():
	GameManagerSignalBus.pause_requested.emit()
	GameManagerSignalBus.switch_scene_by_path.emit("res://scenes/main_menu/main_menu.tscn")
