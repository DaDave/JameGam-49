class_name Player extends CharacterBody2D

@export_subgroup("Nodes")
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var input_component: InputComponent

@export_subgroup("Settings")
@export var iframe_length = 0.2 # in seconds

var is_iframed = false

func _process(delta: float) -> void:
	animation_component.handle_move_animation(input_component.input_horizontal, input_component.input_vertical)
	animation_component.handle_dodge_roll_animation(input_component.wants_to_dodge(), input_component.input_horizontal, input_component.input_vertical)
	movement_component.handle_movement(self, input_component.input_horizontal, input_component.input_vertical)
	movement_component.handle_dodge(self, animation_component.is_dodging, input_component.input_horizontal, input_component.input_vertical)
	_handle_dodge_iframe(animation_component.is_dodging)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.has_method("interact") && input_component.wants_to_interact():
			if !animation_component.is_interacting:
				_handle_interaction(collider)

func _handle_interaction(interactable):
	animation_component.handle_interaction()
	await get_tree().create_timer(0.2).timeout
	interactable.interact()

func _handle_dodge_iframe(is_dodging): #TODO: noch testen
	if is_dodging and !is_iframed:
		self.set_collision_layer_value(3, false)
		is_iframed = true
		await get_tree().create_timer(iframe_length).timeout
		self.set_collision_layer_value(3, true)
	if !is_dodging and is_iframed:
		is_iframed = false
