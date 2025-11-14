class_name MovementComponent extends Node

@export_subgroup("Settings")
@export var speed: float = 100.0
@export var dodge_speed: float = 300.0

var current_direction_horizontal: float
var current_direction_vertical: float

func handle_movement(body: CharacterBody2D, direction_horizontal: float, direction_vertical: float):
	body.velocity.x = direction_horizontal * speed
	body.velocity.y = direction_vertical * speed
	
func handle_dodge(body: CharacterBody2D, is_dodging: bool, direction_horizontal: float, direction_vertical: float):
	if is_dodging:
		body.velocity.x = current_direction_horizontal * dodge_speed
		body.velocity.y = current_direction_vertical * dodge_speed
	else:
		current_direction_horizontal = direction_horizontal
		current_direction_vertical = direction_vertical
