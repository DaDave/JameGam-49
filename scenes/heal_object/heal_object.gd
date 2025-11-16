class_name HealObject
extends Area2D

@export var heal_amount: int = 99
@export var sprite_frames: SpriteFrames

func _ready():
	if (sprite_frames != null):
		%AnimatedSprite2D.sprite_frames = sprite_frames

func _on_body_entered(body):
	if (body is Player):
		GameManagerSignalBus.increase_player_health.emit(heal_amount)
		$".".queue_free()
