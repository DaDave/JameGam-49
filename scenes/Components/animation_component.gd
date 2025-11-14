class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

var up: bool = false 
var down: bool = true 
var left: bool = false 
var right: bool = false 

var is_dodging: bool = false

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)

func handle_move_animation(direction_horizontal: float, direction_vertical: float) -> void:
	if !is_dodging:
		if left:
			if direction_horizontal != 0: sprite.play("run_left")
			else: sprite.play("idle_left")
		elif right:
			if direction_horizontal != 0: sprite.play("run_right")
			else: sprite.play("idle_right")
		elif up:
			if direction_vertical != 0: sprite.play("run_up")
			else: sprite.play("idle_up")
		elif down:
			if direction_vertical != 0: sprite.play("run_down")
			else: sprite.play("idle_down")
	
	up = direction_vertical < 0
	down = direction_vertical > 0
	left = direction_horizontal < 0
	right = direction_horizontal > 0

func handle_dodge_roll_animation(wants_to_dodge: bool, direction_horizontal: float, direction_vertical: float) -> void:
	if wants_to_dodge:
		if sprite.animation.contains("up"):
			sprite.play("dodge_up")
		elif sprite.animation.contains("down"):
			sprite.play("dodge_down")
		elif sprite.animation.contains("left"):
			sprite.play("dodge_left")
		elif sprite.animation.contains("right"):
			sprite.play("dodge_right")
		is_dodging = true

func _on_animation_finished() -> void:
	if is_dodging && sprite.animation.contains("dodge"):
		is_dodging = false
	
	
