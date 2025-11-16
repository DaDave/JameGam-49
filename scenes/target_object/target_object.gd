class_name TargetObject

extends StaticBody2D

@export_subgroup("Nodes")
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D

@export var box_closed_sprite: Texture2D
@export var box_closed_1_sprite: Texture2D
@export var box_open_half_sprite: Texture2D
@export var box_open_half_1_sprite: Texture2D
@export var box_open_full_sprite: Texture2D
@export var box_open_full_1_sprite: Texture2D

@export var room_number: int

var interactable = false

func _ready() -> void:
	GameManagerSignalBus.register_target_object.emit(self)
	visible = false
	set_collision_layer_value(1, false)

func execute_alert_closed_light() -> void:
	while(!interactable):
		sprite.texture = box_closed_sprite
		await get_tree().create_timer(1).timeout
		sprite.texture = box_closed_1_sprite
		await get_tree().create_timer(1).timeout

func execute_alert_open_light() -> void:
	interactable = true
	while(interactable):
		sprite.texture = box_open_full_sprite
		await get_tree().create_timer(1).timeout
		sprite.texture = box_open_full_1_sprite
		await get_tree().create_timer(1).timeout
		
func interact() -> void:
	if interactable:
		GameManagerSignalBus.game_over.emit(true)
