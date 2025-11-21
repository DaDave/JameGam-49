class_name HealObject
extends Area2D

@export var heal_amount: int = 0
@export var sprite_frames: SpriteFrames

func _ready():
	if (sprite_frames != null):
		%AnimatedSprite2D.sprite_frames = sprite_frames
	_setup_difficulty()

func _on_body_entered(body):
	if (body is Player):
		GameManagerSignalBus.increase_player_health.emit(heal_amount)
		$".".queue_free()

func _setup_difficulty() -> void:
	var difficulty = GameManager.getDifficulty()
	
	# HARD ist der Default fuer die eingestellten Werte
	match difficulty:
		GameManager.DIFFICULTY_BABY:
			_set_heal_amount(5)
		GameManager.DIFFICULTY_EASY:
			_set_heal_amount(3)
		GameManager.DIFFICULTY_NORMAL:
			_set_heal_amount(3)
		GameManager.DIFFICULTY_HARD:
			_set_heal_amount(2)
		GameManager.DIFFICULTY_HELL:
			_set_heal_amount(2)
		GameManager.DIFFICULTY_MADNESS:
			_set_heal_amount(2)

func _set_heal_amount(amount: int):
	# @export hat prio ueber Schwierigkeitsgrad
	if (heal_amount != 0):
		return
	
	heal_amount = amount
