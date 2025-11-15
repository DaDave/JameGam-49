class_name TargetObject

extends StaticBody2D

@export_subgroup("Nodes")
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D

@export var closed_box_sprite: Texture2D
@export var open_box_light_a_sprite: Texture2D
@export var open_box_light_b_sprite: Texture2D

@export var room_number: int

var interactable = false

func _ready() -> void:
	GameManagerSignalBus.register_target_object.emit(self)
	visible = false

func execute_alert_light() -> void:
	interactable = true
	while(true):
		sprite.texture = open_box_light_a_sprite
		await get_tree().create_timer(1).timeout
		sprite.texture = open_box_light_b_sprite
		await get_tree().create_timer(1).timeout
		
func interact() -> void:
	if interactable:
		GameManagerSignalBus.game_over.emit(true)
