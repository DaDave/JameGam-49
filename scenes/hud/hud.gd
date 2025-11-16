class_name Hud extends Control

@export_subgroup("Nodes")
@export var healthbar: HBoxContainer
@export var heart_scene: PackedScene

var is_initialized = false
var hearts:Array = []

func _ready():
	GameManagerSignalBus.game_started.connect(_on_game_started)
	GameManagerSignalBus.decrease_player_health.connect(_on_decrease_player_health)

func add_heart():
	var new_heart = heart_scene.instantiate()
	healthbar.add_child(new_heart)
	hearts.append(new_heart)

func remove_heart():
	if !hearts.size() == 0 and is_initialized:
		var last_heart = hearts.pop_back()
		healthbar.remove_child(last_heart)
		last_heart.queue_free()

func _on_game_started():
	var heart_count = GameManager.max_player_health
	for n in heart_count:
		add_heart()
	is_initialized = true

func _on_decrease_player_health():
	remove_heart()
	if(hearts.size() == 1):
		hearts[0].make_critical()
