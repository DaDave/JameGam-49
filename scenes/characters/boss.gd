class_name Boss extends CharacterBody2D

@export_subgroup("Nodes")
@export var animation_component: AnimationComponent
@export var movement_component: MovementComponent

@export_subgroup("Settings")
@export var input_horizontal: float
@export var input_vertical: float

func _process(delta: float) -> void:
	print("X: ", input_horizontal, "Y: ", input_vertical)
	animation_component.handle_move_animation(input_horizontal, input_vertical)
	movement_component.handle_movement(self, input_horizontal, input_vertical)
	move_and_slide()
