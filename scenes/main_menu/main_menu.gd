class_name MainMenu

extends Control

func _ready() -> void:
	%OptionButton.select(GameManager.getDifficulty())

func _on_start_button_pressed():
	GameManagerSignalBus.switch_scene_by_path.emit("res://scenes/cinematics/intro_text.tscn")

func _on_credits_button_pressed():
	$CreditsLabel.visible = !$CreditsLabel.visible
	$ControlsLabel.visible = !$ControlsLabel.visible

func _on_quit_button_pressed():
	get_tree().quit()


func _on_option_button_item_selected(index):
	GameManagerSignalBus.set_difficulty.emit(index)
