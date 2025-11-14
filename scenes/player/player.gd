class_name Player extends CharacterBody2D

@export_subgroup("Nodes")
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var input_component: InputComponent

var is_interacting: bool = false

func _process(delta: float) -> void:
	animation_component.handle_move_animation(input_component.input_horizontal, input_component.input_vertical)
	animation_component.handle_dodge_roll_animation(input_component.wants_to_dodge(), input_component.input_horizontal, input_component.input_vertical)
	movement_component.handle_movement(self, input_component.input_horizontal, input_component.input_vertical)
	movement_component.handle_dodge(self, animation_component.is_dodging, input_component.input_horizontal, input_component.input_vertical)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.has_method("interact") && input_component.wants_to_interact():
			if !is_interacting:
				_handle_interaction(collider)

func _handle_interaction(interactable):
	is_interacting = true
	animation_component.handle_interaction()
	interactable.interact()
