extends CharacterBody2D


const MAX_SPEED = 750
const JUMP_VELOCITY = -400.0
const FRICTION = 1400
const ACCELERATION = 2500
const AIR_CONTROL = 1
const TURN_ACCELERATION = 6000

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if direction != 0:
		# Check if player is trying to reverse direction
		var is_turning = sign(velocity.x) != 0 and sign(velocity.x) != direction
		
		# Pick acceleration base rate
		var base_accel = TURN_ACCELERATION if is_turning else ACCELERATION
		var accel = base_accel if is_on_floor() else base_accel * AIR_CONTROL

		# Preserve momentum if already moving faster than MAX_SPEED in the same direction
		if abs(velocity.x) < MAX_SPEED or is_turning:
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, accel * delta)
	else:
		var fric = FRICTION if is_on_floor() else FRICTION * AIR_CONTROL
		velocity.x = move_toward(velocity.x, 0, fric * delta)

	move_and_slide()
