class_name MovementComponent extends Node

@export_subgroup("Settings")
@export var speed: float = 100.0

func handle_movement(body: CharacterBody2D, direction_horizontal: float, direction_vertical: float):
	body.velocity.x = direction_horizontal * speed
	body.velocity.y = direction_vertical * speed
