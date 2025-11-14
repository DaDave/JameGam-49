class_name Player extends CharacterBody2D

@export_subgroup("Nodes")
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var input_component: InputComponent

func _process(delta: float) -> void:
	movement_component.handle_movement(self, input_component.input_horizontal, input_component.input_vertical)
	animation_component.handle_move_animation(input_component.input_horizontal, input_component.input_vertical)
	move_and_slide()
