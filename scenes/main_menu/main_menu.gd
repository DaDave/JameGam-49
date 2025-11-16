class_name MainMenu

extends Control

func _on_start_button_pressed():
	GameManagerSignalBus.switch_scene_by_path.emit("res://scenes/game/game.tscn")

func _on_credits_button_pressed():
	$CreditsLabel.visible = !$CreditsLabel.visible
	$ControlsLabel.visible = !$ControlsLabel.visible

func _on_quit_button_pressed():
	get_tree().quit()
