extends CharacterBody3D

@export_category("Min/Max Speed")
## Minimum Speed that the mob can move at
@export var min_speed = 10
## Maximum Speed that the mob can move at
@export var max_speed = 25

signal squashed

func _physics_process(delta):
	move_and_slide()

func initialize(start_position, player_position):
	# Place the mob at the `start_position` and make it look towards the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Randomly rotate the mob withing 45 degrees cw or ccw of its original direciton.
	rotate_y(randf_range(-PI / 4, PI / 4))
	# Generate a random integer speed out of the maximum and minimum speed values.
	var random_speed = randi_range(min_speed, max_speed)
	# Make the velocity the forward vecotor times the random speed
	velocity = Vector3.FORWARD * random_speed
	# Rotate the velocity vector by the rotation of the object
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()
