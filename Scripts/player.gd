extends CharacterBody2D

const MOVEMENT_SPEED = 240 # Base speed of travel
const DODGE_SPEED: float = 120 # Initial roll speed
const DODGE_DURATION: float = 0.3 # Duration of roll in seconds

# Internal state variables. 
var dodge_roll_dir: Vector2 = Vector2.ZERO # don't export me!!! noo!!! 
var dodge_roll_timer: float = 0.0  # Me neither!!

@export var can_take_damage: bool = true # Toggled off during i-frames. exported for debug purposes
@export var accel: float = 22 

func _physics_process(delta: float) -> void:
	if dodge_roll_timer > 0.0:
		_dodge_logic(delta) # Handle roll physics if active
	else:
		_movement(delta) # Handle normal movement otherwise
		
	move_and_slide() # Apply the velocity to the character

func _movement(delta: float) -> void:
	# Normalizes speed to avoid strafing boost. debateable.
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	# Smoothly accelerate towards the input direction
	velocity = lerp(velocity, input_vector * MOVEMENT_SPEED, accel * delta)
	
	if Input.is_action_just_pressed("roll"):
		if input_vector != Vector2.ZERO:
			dodge_roll(input_vector) # Roll in the direction of input
		elif velocity.length() > 0.1:
			dodge_roll(velocity.normalized()) # Roll in the direction of momentum if standing still

func dodge_roll(direction: Vector2) -> void:
	dodge_roll_dir = direction # Lock in the roll direction
	dodge_roll_timer = DODGE_DURATION # Start the countdown
	can_take_damage = false # Invincibility enabled
	
	# Sync the animation speed to perfectly match the roll duration
	$Sprite2D/RollAnim.speed_scale = 1.0 / DODGE_DURATION
	# Play left or right roll animation depending on direction
	$Sprite2D/RollAnim.play("roll_left_ccw_2" if direction.x < 0 else "roll_right_cw")

func _dodge_logic(delta: float) -> void:
	# Calculates decimal of roll progress
	var elapsed_percent = 1.0 - (dodge_roll_timer / DODGE_DURATION)
	
	# Slows speed near the end of the roll. Not tweening because it's annoying and this looks good linear.
	var current_speed = lerp(DODGE_SPEED, DODGE_SPEED * 0.5, elapsed_percent)
	
	velocity = dodge_roll_dir * current_speed # Actually apply the roll speed to velocity
	
	dodge_roll_timer -= delta # Tick down the timer
	
	if dodge_roll_timer <= 0.0: # Triggered upon completion of roll
		dodge_roll_dir = Vector2.ZERO
		can_take_damage = true # Invincibility begone
