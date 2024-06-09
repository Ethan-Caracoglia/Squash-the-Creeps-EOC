extends CharacterBody3D

## Speed of player
@export var speed = 5
## Downward acceleration due to gravity
@export var grav_acceleration = 98
## Jump impulse magnitude
@export var jump_impulse = 20
## Impulse variable for bouncing off of the enemies when you jump on them
@export var bounce_impulse = 15
## Player desired velocity
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# Stores the input direction
	var direction = Vector3.ZERO
	
	# Check for each move input and update the directions accordingly
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	
	# Normalize the direction if it is not equal to ZERO
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Point the player towards the movement direction
		$pivot.basis = Basis.looking_at(direction)
	
	# Calculate Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed 
	
	# Vertical velocity
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (grav_acceleration * delta)
		
	# Jumping logic
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	# Bounces off a monster if you collide in the air
	for index in range(get_slide_collision_count()):
		# Get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		# Check to see if the collision is with the ground.
		if collision.get_collider() == null:
			continue
		
		# Check to see if the collision is with the player
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# Check for a collision from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break
			
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
