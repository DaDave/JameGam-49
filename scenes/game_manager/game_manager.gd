extends Node

var max_player_health: int
var interaction_countdown: int
var checkpoint_objects: Array[CheckpointObject]
var target_objects: Array[TargetObject]
var selected_target_object: TargetObject
var pause_menu_instance : PauseMenu = null
var game_over_instance: GameOverMenu
var occupied_room_values: Array
var isPaused : bool = false
var current_scene = null
var button_rooms: Array[int] = []
var box_room: int

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	GameManagerSignalBus.switch_scene_by_path.connect(_onSceneByPathSwitched)
	GameManagerSignalBus.start_game.connect(_onGameStarted)
	GameManagerSignalBus.pause_menu_initiated.connect(_onPauseMenuInitiated)
	GameManagerSignalBus.pause_requested.connect(_onPauseRequested)
	GameManagerSignalBus.game_over_menu_initiated.connect(_onGameOverMenuInitiated)
	GameManagerSignalBus.game_over.connect(_onGameOver)
	GameManagerSignalBus.game_quitted.connect(_onGameQuitted)
	GameManagerSignalBus.register_checkpoint_object.connect(_onCheckpointObjectRegistered)
	GameManagerSignalBus.interact_checkpoint_object.connect(_onCheckpointObjectInteracted)
	GameManagerSignalBus.register_target_object.connect(_onTargetObjectRegistered)
	GameManagerSignalBus.decrease_player_health.connect(_onPlayerHealthDecreased)

func _onSceneByPathSwitched(path: String) -> void:
	call_deferred("_deferred_switch_scene", path)

func _onGameStarted() -> void:
	max_player_health = 10
	interaction_countdown = 2
	## select checkpoint a
	var room_value_checkpoint_a = select_random_room_for_object()
	var checkpoint_a_index = checkpoint_objects.find_custom(func(checkpoint_object):
		return checkpoint_object.room_number == room_value_checkpoint_a
	)
	print("selected checkpoint a room index: " + str(checkpoint_a_index))
	var checkpoint_a = checkpoint_objects[checkpoint_a_index]
	checkpoint_a.visible = true
	checkpoint_a.interactable = true
	button_rooms.append(checkpoint_a_index)
	
	## select checkpoint b
	var room_value_checkpoint_b = select_random_room_for_object()
	var checkpoint_b_index = checkpoint_objects.find_custom(func(checkpoint_object):
		return checkpoint_object.room_number == room_value_checkpoint_b
	)
	print("selected checkpoint b room index: " + str(checkpoint_b_index))
	var checkpoint_b = checkpoint_objects[checkpoint_b_index]
	checkpoint_b.visible = true
	checkpoint_b.interactable = true
	button_rooms.append(checkpoint_b_index)
	
	## select target 
	var room_value_target = select_random_room_for_object()
	var target_index = target_objects.find_custom(func(target_object):
		return target_object.room_number == room_value_target
	)
	print("selected target room index: " + str(target_index))
	var target = target_objects[target_index]
	target.visible = true
	box_room = target_index
	
	selected_target_object = target
	selected_target_object.execute_alert_closed_light()
	
	GameTimer.one_shot = true
	GameTimer.start(180)
	
	GameManagerSignalBus.game_started.emit()
	

func _onPauseMenuInitiated(pause_menu: PauseMenu) -> void:
	pause_menu_instance = pause_menu

func _onPauseRequested() -> void:
	if(isPaused):
		pause_menu_instance.hide()
	else:
		pause_menu_instance.show()
	pause()

func _onGameOverMenuInitiated(game_over: GameOverMenu) -> void:
	game_over_instance = game_over

func _onGameOver(successful: bool) -> void:
	pause()
	if successful:
		game_over_instance.set_text("You did it!")
	else:
		game_over_instance.set_text("You blew up!")
	game_over_instance.show()
	
func _onGameQuitted() -> void:
	occupied_room_values = []
	checkpoint_objects = []
	target_objects = []
	pause()

func _onCheckpointObjectRegistered(checkpoint_object: CheckpointObject) -> void:
	print("Register checkpoint object with room number" + str(checkpoint_object.room_number))
	checkpoint_objects.append(checkpoint_object)
	
func _onCheckpointObjectInteracted() -> void:
	print("Interact with checkpoint object")
	interaction_countdown = interaction_countdown-1
	if interaction_countdown <= 0:
		print("target is interactable")
		selected_target_object.execute_alert_open_light()

func _onTargetObjectRegistered(target_object: TargetObject) -> void:
	print("Register target object with room number" + str(target_object.room_number))
	target_objects.append(target_object)
	
func _onPlayerHealthDecreased() -> void:
	print(max_player_health)
	max_player_health = max_player_health-1
	print(max_player_health)
	if max_player_health <= 0:
		print("game_over")
		_onGameOver(false)

func _deferred_switch_scene(scene_path):
	current_scene.free()
	var scene = load(scene_path)
	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func select_random_room_for_object() -> int:
	var availableRoomValues = Rooms.values().filter(func(value):
		return not occupied_room_values.has(value)
	)
	var selectedRoomValue = availableRoomValues.pick_random()
	occupied_room_values.append(selectedRoomValue)
	return selectedRoomValue

func pause():
	if isPaused:
		Engine.time_scale = 1
		get_tree().paused = false
	else:
		Engine.time_scale = 0
		get_tree().paused = true
	
	isPaused = !isPaused

## ROOM ENUM 
enum Rooms {COFFEE_KITCHEN, BOSS_OFFICE, WAREHOUSE, RECEPTION, RESTROOM, MEETINGROOM, OPEN_PLAN_OFFICE}

const COFFEE_KITCHEN = 0
const BOSS_OFFICE = 1
const WAREHOUSE = 2
const RECEPTION = 3
const RESTROOM = 4
const MEETINGROOM = 5
const OPEN_PLAN_OFFICE = 6
