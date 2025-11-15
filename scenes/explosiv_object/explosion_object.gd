class_name ExplosionObject
extends Node2D

#region variables
@export var animated_sprite: AnimatedSprite2D
@export var collision_area: Area2D
@export var danger_area: Area2D

@export var count_per_projectile:int = 1
var projectile_counter:int = 0
@export var projectile_angle_deg:int = 0:
	set(value):
		projectile_angle_deg = value
		projectile_angle_rad = deg_to_rad(value)
var projectile_angle_rad:float
@export var projectile_objects:Array[Resource]

@export var pixel_for_explosion:int = 1000

var is_exploded:bool = false
var movement_pixel:int = 0 :
	set(value):
		if (movement_pixel >= pixel_for_explosion && !is_exploded):
			_explode()
		movement_pixel = value

var player:Player
var last_position:Vector2
#endregion

func _process(_delta) -> void:
	_track_player()

#region explode
func _explode() -> void:
	is_exploded = true
	#_animate_explosion()
	_spawn_projectiles()

func _animate_explosion() -> void:
	#TODO: animate explosion
	print("ExplosionObject - _animate_explosion")
	#TODO: queue free after explosion finished => time? tween?
	$"..".queue_free()

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
	
	#TODO: add to parent or something else => else projectiles will be removed on queue_free()
	self.add_child(projectile)

func _calculate_angle(count) -> float:
	var amount: int = (count + 1) / 2
	var pos_neg: int = 1
	if (count % 2 == 1):
		pos_neg = -1
	
	var return_angle: float = projectile_angle_rad * amount * pos_neg
	#print(str("Count: ", count, " - Winkel: ", projectile_angle_deg, " - Winkel Rad: ", projectile_angle_rad, " - Anzahl: ", amount, " - pos_neg: ", pos_neg, " - calc: ", return_angle))
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
#endregion


func _on_danger_area_2d_body_entered(body) -> void:
	if (body is Player):
		player = body

func _on_danger_area_2d_body_exited(body) -> void:
	if (body is Player):
		player = null
