extends Node

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManagerSignalBus.pause_requested.emit()
