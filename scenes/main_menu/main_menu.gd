class_name MainMenu

extends Control

func _on_start_button_pressed():
	GameManagerSignalBus.switch_scene_by_path.emit("res://Scenes/level_1.tscn")

func _on_credits_button_pressed():
	$CreditsLabel.visible = !$CreditsLabel.visible

func _on_quit_button_pressed():
	get_tree().quit()
