class_name Hud extends Control

@export_subgroup("Nodes")
@export var healthbar: HBoxContainer
@export var heart_scene: PackedScene
@export var countdown_label: Label
@export var button_objective_1: Label
@export var button_objective_2: Label
@export var box_objective: Label

@export_subgroup("Settings")
@export var countdown_label_text: String = "{0}"
@export var button_objective_text = "{0}.Get to the {1}\n and push the button!"
@export var box_objective_text = "3.Get to the {0}\n and get in the box!"

var room_names = {
	GameManager.COFFEE_KITCHEN: "Coffee Kitchen",
	GameManager.BOSS_OFFICE: "Boss office",
	GameManager.WAREHOUSE: "Warehouse",
	GameManager.RECEPTION: "Reception",
	GameManager.RESTROOM: "Restroom",
	GameManager.MEETINGROOM: "Meeting Room",
	GameManager.OPEN_PLAN_OFFICE: "Big office"
}

var is_initialized = false
var hearts:Array = []

func _ready():
	GameManagerSignalBus.game_started.connect(_on_game_started)
	GameManagerSignalBus.decrease_player_health.connect(_on_decrease_player_health)
	
func _process(delta) -> void:
	countdown_label.text = countdown_label_text.format([roundi(GameTimer.time_left)])

func add_heart():
	var new_heart = heart_scene.instantiate()
	healthbar.add_child(new_heart)
	hearts.append(new_heart)

func remove_heart():
	if !hearts.size() == 0 and is_initialized:
		var last_heart = hearts.pop_back()
		healthbar.remove_child(last_heart)
		last_heart.queue_free()
		
func initialize_hearts():
	var heart_count = GameManager.max_player_health
	for n in heart_count:
		add_heart()
		
func initialize_objectives():
	var button_rooms = GameManager.button_rooms
	var box_room = GameManager.box_room
	var i = 0
	for room in button_rooms:
		i = i+1;
		if i == 1:
			button_objective_1.text = button_objective_text.format([i, room_names[room]])
		if i == 2:
			button_objective_2.text = button_objective_text.format([i, room_names[room]])
	box_objective.text = box_objective_text.format([room_names[box_room]])

func _on_game_started():
	initialize_hearts()
	initialize_objectives()
	is_initialized = true

func _on_decrease_player_health():
	remove_heart()
	if(hearts.size() == 1):
		hearts[0].make_critical()
