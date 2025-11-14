class_name InputComponent extends Node

var input_horizontal: float = 0.0
var input_vertical: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_horizontal = Input.get_axis("player_left", "player_right")
	input_vertical = Input.get_axis("player_up", "player_down")

func wants_to_interact() -> bool:
	return Input.is_action_just_pressed("player_interact")

func wants_to_dodge() -> bool:
	return Input.is_action_just_pressed("player_dodge")
