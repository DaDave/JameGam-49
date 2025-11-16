class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D
@export var audio_stream_player: AudioStreamPlayer2D

@export_subgroup("Settings")
@export var hurt_flash_time = 0.2

@export_subgroup("Sounds")
@export var hurt_sound: AudioStreamWAV
@export var walk_sound: AudioStreamWAV
@export var death_sound: AudioStreamWAV
@export var dodge_sound: AudioStreamMP3

var up: bool = false 
var down: bool = true 
var left: bool = false 
var right: bool = false 

var is_dodging: bool = false
var is_interacting: bool = false

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)

func handle_move_animation(direction_horizontal: float, direction_vertical: float) -> void:
	if !is_dodging and !is_interacting:
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
	#if sprite.animation.contains("run") and !audio_stream_player.playing:
		#audio_stream_player.stream = walk_sound
		#audio_stream_player.play()
		
	
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
		if !audio_stream_player.playing:
			audio_stream_player.stream = dodge_sound
			audio_stream_player.play()
		
func handle_interaction() -> void:
	if !is_interacting:
		if sprite.animation.contains("up"):
			sprite.play("interact_up")
		elif sprite.animation.contains("down"):
			sprite.play("interact_down")
		elif sprite.animation.contains("left"):
			sprite.play("interact_left")
		elif sprite.animation.contains("right"):
			sprite.play("interact_right")
		is_interacting = true
		
func handle_player_damage() -> void:
	sprite.modulate = Color(1,0,0)
	audio_stream_player.stop()
	audio_stream_player.volume_db = -15.0
	audio_stream_player.stream = hurt_sound
	audio_stream_player.play()
	audio_stream_player.volume_db = 0
	await get_tree().create_timer(hurt_flash_time).timeout
	audio_stream_player.stop()
	sprite.modulate = Color(1,1,1)

func _on_animation_finished() -> void:
	if is_dodging && sprite.animation.contains("dodge"):
		is_dodging = false
	if is_interacting && sprite.animation.contains("interact"):
		is_interacting = false
	
	
