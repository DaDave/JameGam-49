class_name Projectile
extends Area2D

#region variables
@export var animated_sprite: AnimatedSprite2D
@export var movement_speed: float = 500
@export var max_travel_distance: float = 500
var travelled_distance: float = 0
var movement_vector:Vector2
var rotation_speed: float = 0
var random_number_generator = RandomNumberGenerator.new()
#endregion

func _ready() -> void:
	var random_number = random_number_generator.randi_range(1, 2)
	var direction = -1 if random_number % 2 == 1 else 1
	rotation_speed = (direction * random_number) / 5.0
	_setup_difficulty()

func _process(delta) -> void:
	_move(delta)

func _move(delta: float) -> void:
	if (movement_vector == null):
		return
	
	rotate(rotation_speed)
	global_position += movement_vector * movement_speed * delta
	
	travelled_distance += movement_speed * delta
	if (travelled_distance >= max_travel_distance):
		$"..".queue_free()

func _collide(body) -> void:
	if (body is Player):
		GameManagerSignalBus.decrease_player_health.emit()
	queue_free()

func _setup_difficulty() -> void:
	var difficulty = GameManager.getDifficulty()
	
	# HARD ist der Default fuer die eingestellten Werte
	match difficulty:
		GameManager.DIFFICULTY_BABY:
			_change_difficulty(0.4)
		GameManager.DIFFICULTY_EASY:
			_change_difficulty(0.6)
		GameManager.DIFFICULTY_NORMAL:
			_change_difficulty(0.8)
		GameManager.DIFFICULTY_HELL:
			_change_difficulty(1.05)
		GameManager.DIFFICULTY_MADNESS:
			_change_difficulty(1.10)

func _change_difficulty(multiplier: float):
	movement_speed = movement_speed * multiplier
	max_travel_distance = max_travel_distance * multiplier

func _on_body_entered(body):
	_collide(body)

func _on_timer_layer_timeout():
	self.collision_layer = 4
