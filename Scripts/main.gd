extends Node

@export var mob_scene: PackedScene
@onready var retry_overlay = $user_interface/retry

func _ready():
	retry_overlay.hide()

func _on_mob_timer_timeout():
	# Create a new instance of a mob scene
	var mob = mob_scene.instantiate()
	# Store the referenced to the spawn_location
	var mob_spawn_location = $spawn_path/spawn_location
	# Random location on the spawn_path is chosen
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Spawn the mob by adding it to the main node
	add_child(mob)
	
	mob.squashed.connect($user_interface/score_label._on_mob_squashed.bind())


func _on_player_hit():
	$mob_timer.stop()
	
	retry_overlay.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and retry_overlay.visible:
		# Restart the current scene
		get_tree().reload_current_scene()
		
