extends Node

func _on_timer_timeout():
	GameManagerSignalBus.game_over.emit()
