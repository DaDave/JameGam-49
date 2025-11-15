extends Node

signal start_game()

signal pause_menu_initiated(pause_menu : PauseMenu)

signal pause_requested()

signal quit_level_requested()

signal game_over()

signal game_over_menu_initiated(game_over_closed: GameOverMenu)

signal game_over_menu_quitted()

signal switch_scene_by_path(path: String)

signal decrease_player_health()

signal register_checkpoint_object(checkpoint_object: CheckpointObject)

signal register_target_object(Target_object: TargetObject)
