class_name ExplosionObject
extends Node2D

#region variables
@export var animated_sprite: AnimatedSprite2D
@export var collision_area: Area2D
@export var danger_area: Area2D

@export var projectile_count:int = 1
@export var projectile_angle_deg:int = 10:
	set(value):
		projectile_angle_deg = value
		projectile_angle_rad = deg_to_rad(value)
var projectile_angle_rad:float
@export var projectile_object:Resource #TODO: in richtige Klasse aendern sobald vorhanden

@export var pixel_for_explosion:int = 9999

var is_exploded:bool = false
var movement_pixel:int = 0 :
	set(value):
		if (movement_pixel >= pixel_for_explosion && !is_exploded):
			_explode()
		movement_pixel = value

var player:Node2D
var last_position:Vector2
#endregion

func _process(_delta) -> void:
	_track_player()

#region explode
func _explode() -> void:
	print("ExplosionObject - _explode")
	is_exploded = true
	_animate_explosion()
	_spawn_projectiles()

func _spawn_projectiles() -> void:
	#TODO: spawn projectiles
	print(str("ExplosionObject - _spawn_projectiles: ", projectile_count))
	for count in projectile_count:
		_spawn_projectile(count)

func _spawn_projectile(count: int) -> void:
	print("ExplosionObject - _spawn_projectile")
	var projectile = projectile_object.instantiate()
	projectile.global_position = self.global_position
	#TODO: get player position
	var direction = projectile.global_position.angle_to_point(Vector2.ZERO)
	direction += _calc_angle(count)
	projectile.global_rotation = direction

func _calc_angle(count) -> float:
	var amount: int = (count + 1) / 2
	var pos_neg: int = 1
	if (count % 2 == 1):
		pos_neg = -1
	
	var return_angle: float = projectile_angle_rad * amount * pos_neg
	print(str("Count: ", count, " - Winkel: ", projectile_angle_deg, " - Winkel Rad: ", projectile_angle_rad, " - Anzahl: ", amount, " - pos_neg: ", pos_neg, " - gesamt: ", projectile_angle_rad * amount * pos_neg))
	return return_angle

func _animate_explosion() -> void:
	#TODO: animate explosion
	print("ExplosionObject - _animate_explosion")
	$"..".queue_free()
#endregion

#region track player
func _track_player() -> void:
	print("ExplosionObject - _track_player")
	if (player == null):
		return
	
	if (player == null):
		return
	
	var player_position:Vector2 = Vector2.ZERO #TODO: spater entfernen und direkt die Playerposition verwenden
	if (last_position != null):
		movement_pixel += int((player_position - last_position).length())
	last_position = player_position

func _on_danger_area_2d_area_entered(area) -> void:
	#TODO: set player
	print("ExplosionObject - _on_danger_area_2d_area_entered")

func _on_danger_area_2d_area_exited(area) -> void:
	print("ExplosionObject - _on_danger_area_2d_area_exited")
	#TODO: if area == player
	player = null
#endregion
