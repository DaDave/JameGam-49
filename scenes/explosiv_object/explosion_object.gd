class_name ExplosionObject
extends StaticBody2D

#region variables
@export var animated_sprite: AnimatedSprite2D
@export var danger_area: Area2D
@export var explosion_sound: AudioStreamWAV

@export var count_per_projectile:int = 1
var projectile_counter:int = 0
@export var projectile_angle_deg:int = 0:
	set(value):
		projectile_angle_deg = value
		projectile_angle_rad = deg_to_rad(value)
var projectile_angle_rad:float
@export var projectile_objects:Array[Resource]
@export var pixel_for_explosion:float = 5000
@export var base_percentage:float = 5
var calculated_percentage:float = 0
@export var timer_ticks:float = 0.3

var is_exploded:bool = false
var movement_pixel:int = 0 :
	set(value):
		if (!is_exploded):
			_calculate_percentage()
		movement_pixel = value

var player:Player
var last_position:Vector2
var random_number_generator = RandomNumberGenerator.new()
#endregion

func _ready() -> void:
	animated_sprite.visible = true
	danger_area.body_entered.connect(_on_danger_area_2d_body_entered)
	danger_area.body_exited.connect(_on_danger_area_2d_body_exited)
	%TimerExplosion.wait_time = timer_ticks
	if (explosion_sound != null):
		%AudioStreamPlayer2D.stream = explosion_sound

func _process(_delta) -> void:
	_track_player()

#region explode
func _explode() -> void:
	is_exploded = true
	%AudioStreamPlayer2D.play()
	_animate_explosion()
	_spawn_projectiles()

func _animate_explosion() -> void:
	%ExplosionGPUParticles2D.emitting = true
	_hide_on_explosion()
	
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _hide_on_explosion():
	%Sprite_Explosion.visible = true
	%Sprite_Explosion.play()
	animated_sprite.visible = false
	collision_layer = 0
#endregion

#region projectiles
func _spawn_projectiles() -> void:
	for count in count_per_projectile:
		for projectile in projectile_objects:
			_spawn_projectile(projectile, projectile_counter)
			projectile_counter += 1

func _spawn_projectile(projectile_blueprint: Resource, count: int) -> void:
	var projectile = projectile_blueprint.instantiate()
	if (projectile is not Projectile):
		return
	
	projectile.look_at(player.global_position)
	projectile.set_global_position(global_position)

	var directionVector: Vector2 = player.global_position - projectile.global_position
	var totalVelocity: float = abs(directionVector.x) + abs(directionVector.y)
	var movement_vector = directionVector / totalVelocity
	var direction = _calculate_angle(count)
	projectile.global_rotation = direction
	projectile.movement_vector = movement_vector.rotated(direction)
	
	self.add_child(projectile)

func _calculate_angle(count) -> float:
	var amount: int = (count + 1) / 2
	var pos_neg: int = 1
	if (count % 2 == 1):
		pos_neg = -1
	
	var return_angle: float = projectile_angle_rad * amount * pos_neg
	return return_angle
#endregion

#region track player
func _track_player() -> void:
	if (player == null):
		return
	
	if (player == null):
		return
	
	var player_position:Vector2 = player.global_position
	if (last_position != null):
		movement_pixel += int((player_position - last_position).length())
	last_position = player_position

func _calculate_percentage() -> void:
	calculated_percentage = movement_pixel / pixel_for_explosion * 100
#endregion

func _on_danger_area_2d_body_entered(body) -> void:
	if (body is Player):
		player = body
		%TimerExplosion.start()

func _on_danger_area_2d_body_exited(body) -> void:
	if (body is Player):
		player = null
		if (%TimerExplosion != null):
			%TimerExplosion.stop()

func _on_timer_explosion_timeout():
	var random_number = random_number_generator.randf_range(0, 100)
	if (random_number <= (base_percentage + calculated_percentage) && !is_exploded):
		_explode()
