extends CharacterBody3D


@export var acceleration = 1.5
@export var brake_force = 0.3
@export var turn_speed = 0.002
@export var angular_friction = 0.95
@export var friction = 0.95
@export var control = 0
var angular_velocity = 0 # since we are only rotating on Z, this is a float

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# dot product of velocity clamped gives
	var velocity_alpha = clamp(velocity.dot(velocity), 0, 1)
	
	if Input.is_action_pressed("accelerate"):
		velocity -= transform.basis.z * acceleration
	if Input.is_action_pressed("reverse"):
		velocity += transform.basis.z * brake_force
	if Input.is_action_pressed("turn_left"):
		angular_velocity += turn_speed * velocity_alpha
	if Input.is_action_pressed("turn_right"):
		angular_velocity -= turn_speed * velocity_alpha
	
	
	angular_velocity *= angular_friction * velocity_alpha
	velocity *= friction
	
	# jankily apply angular velocity
	rotate(Vector3.UP, angular_velocity)
	
	move_and_slide()
