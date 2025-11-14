class_name RedButton extends StaticBody2D

@export_subgroup("Nodes")
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D

@export var up_button_sprite: Texture2D
@export var down_button_sprite: Texture2D
@export var up_button_active_sprite: Texture2D

var is_pressed: bool = false

func _ready():
	sprite.texture = up_button_sprite
	
func interact():
	print("Interacted!")
	is_pressed = true
	sprite.texture = down_button_sprite
	await get_tree().create_timer(1).timeout
	sprite.texture = up_button_active_sprite
