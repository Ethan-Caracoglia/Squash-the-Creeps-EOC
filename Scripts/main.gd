extends Node

@export var mob_scene: PackedScene


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
