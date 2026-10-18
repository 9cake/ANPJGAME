extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var can_jump = false

@onready var camera: Camera2D = $Camera2D
var is_zoom = false
var normal_zoom := Vector2(3.0,3.0)
var zoomed_out := Vector2(0.5,0.5)

var is_flying := false	



func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Z:
			is_zoom = !is_zoom


func jump():
	velocity.y = JUMP_VELOCITY
	can_jump = false
	$CoyoteTimer.stop()
func _on_coyote_timer_timeout():
	can_jump = false

func _physics_process(delta: float) -> void:
	
		
	if camera:
		var zoom = zoomed_out if is_zoom else normal_zoom
		camera.zoom = camera.zoom.lerp(zoom, 10.0 * delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if is_on_floor():
		can_jump = true
	elif can_jump and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start()
	
	if Input.is_action_just_pressed("jump") and can_jump:
		jump()
	# Get the input direction and handle the movement/deceleration. 
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
