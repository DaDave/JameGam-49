extends Timer

func _ready():
	timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	GameManagerSignalBus.game_over.emit(false)
