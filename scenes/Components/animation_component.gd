class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

var up: bool = false 
var down: bool = true 
var left: bool = false 
var right: bool = false 

func _ready():
	sprite.frame_changed.connect(_on_frame_changed)

func handle_move_animation(direction_horizontal: float, direction_vertical: float) -> void:
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

func _on_frame_changed():
	if sprite.animation.contains("show_card") && sprite.frame == 6:
		sprite.pause()
