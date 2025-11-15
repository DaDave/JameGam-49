class_name Projectile
extends Area2D

#region variables
@export var animated_sprite: AnimatedSprite2D
@export var movement_speed: int = 500
@export var max_travel_distance: float = 500
var travelled_distance: float = 0
var movement_vector:Vector2
#endregion

func _process(delta) -> void:
	_move(delta)

func _move(delta: float) -> void:
	if (movement_vector == null):
		return
	
	global_position += movement_vector * movement_speed * delta
	
	travelled_distance += movement_speed * delta
	if (travelled_distance >= max_travel_distance):
		queue_free()

func _collide(body) -> void:
	print("_collide")
	if (body is Player):
		#TODO: deal damage to the player
		print("deal damage")
	queue_free()

func _on_body_entered(body):
	print("_on_body_entered")
	#TODO: Wieso wird der Player nicht erkannt?
	_collide(body)
