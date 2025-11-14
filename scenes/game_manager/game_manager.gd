extends Node

var max_player_health: int
var checkpoint_objects: Array[CheckpointObject]
var target_objects: Array[TargetObject]
var pause_menu_instance : PauseMenu = null
var game_over_instance: GameOverMenu
var occupied_room_values: Array
var isPaused : bool = false

func _ready() -> void:
	GameManagerSignalBus.switch_scene_by_path.connect(_onSceneByPathSwitched)
	GameManagerSignalBus.start_game.connect(_onGameStarted)
	GameManagerSignalBus.pause_menu_initiated.connect(_onPauseMenuInitiated)
	GameManagerSignalBus.pause_requested.connect(_onPauseRequested)
	GameManagerSignalBus.game_over_menu_initiated.connect(_onGameOverMenuInitiated)
	GameManagerSignalBus.game_over.connect(_onGameOver)
	GameManagerSignalBus.register_checkpoint_object.connect(_onCheckpointObjectRegistered)
	GameManagerSignalBus.register_target_object.connect(_onTargetObjectRegistered)
	GameManagerSignalBus.decrease_player_health.connect(_onPlayerHealthDecreased)

func _onSceneByPathSwitched(path: String) -> void:
	call_deferred("_deferred_switch_scene", path)

func _onGameStarted() -> void:
	max_player_health = 3
	var room_value_checkpoint_a = select_random_room_for_object()
	var checkpoint_a = checkpoint_objects.filter(func(checkpoint_object):
		return checkpoint_object.room_number == room_value_checkpoint_a
	)
	## TODO: Make checkpoint_a visible
	var room_value_checkpoint_b = select_random_room_for_object()
	var checkpoint_b = checkpoint_objects.filter(func(checkpoint_object):
		return checkpoint_object.room_number == room_value_checkpoint_b
	)
	## TODO: Make checkpoint_b visible
	var room_value_target = select_random_room_for_object()
	var target = target_objects.filter(func(target_object):
		return target_object.room_number == room_value_target
	)
	## TODO: Make target visible
	
	GameTimer.one_shot = true
	GameTimer.start(180)
	

func _onPauseMenuInitiated(pause_menu: PauseMenu) -> void:
	pause_menu_instance = pause_menu

func _onPauseRequested() -> void:
	pause()

func _onGameOverMenuInitiated(game_over: GameOverMenu) -> void:
	game_over_instance = game_over

func _onGameOver() -> void:
	game_over_instance.show()

func _onCheckpointObjectRegistered(checkpoint_object: CheckpointObject) -> void:
	checkpoint_objects.append(checkpoint_object)

func _onTargetObjectRegistered(target_object: TargetObject) -> void:
	target_objects.append(target_object)
	
func _onPlayerHealthDecreased() -> void:
	max_player_health = max_player_health-1
	if max_player_health <= 0:
		_onGameOver()

func select_random_room_for_object() -> int:
	var availableRoomValues = Rooms.values().filter(func(value):
		return not occupied_room_values.has(value)
	)
	var selectedRoomValue = availableRoomValues.pick_random()
	occupied_room_values.append(selectedRoomValue)
	return selectedRoomValue

func pause():
	if isPaused:
		pause_menu_instance.hide()
		Engine.time_scale = 1
		get_tree().paused = false
	else:
		pause_menu_instance.show()
		Engine.time_scale = 0
		get_tree().paused = true
	
	isPaused = !isPaused

## ROOM ENUM 
enum Rooms {COFFEE_KITCHEN, BOSS_OFFICE, WAREHOUSE, RECEPTION, RESTROOM, CHANGING_ROOM, OPEN_PLAN_OFFICE}

const COFFEE_KITCHEN = 0
const BOSS_OFFICE = 1
const WAREHOUSE = 2
const RECEPTION = 3
const RESTROOM = 4
const CHANGING_ROOM = 5
const OPEN_PLAN_OFFICE = 6
