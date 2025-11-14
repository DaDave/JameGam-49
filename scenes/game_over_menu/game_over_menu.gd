class_name GameOverMenu

extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_quit_button_pressed():
	GameManagerSignalBus.switch_scene_by_path.emit("res://MainMenu/main_menu.tscn")
