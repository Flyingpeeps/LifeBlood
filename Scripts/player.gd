extends CharacterBody2D

const MOVEMENT_SPEED = 240

const DODGE_SPEED: float = 120
const DODGE_DURATION: float = 0.3

@export var dodge_roll_dir: Vector2 = Vector2.ZERO
@export var dodge_roll_timer: float = 0.0

@export var can_take_damage: bool = true

@export var accel: float = 22

func _physics_process(delta: float) -> void:
	if dodge_roll_timer > 0.0:
		_dodge_logic(delta)
	else:
		_movement(delta)
	move_and_slide()

func _movement(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	velocity = lerp(velocity, input_vector * MOVEMENT_SPEED, accel * delta)
	if Input.is_action_just_pressed("roll"):
		if input_vector != Vector2.ZERO:
			dodge_roll(input_vector)
		elif velocity.length() > 0.1:
			dodge_roll(velocity.normalized())

func dodge_roll(direction: Vector2) -> void:
	dodge_roll_dir = direction
	dodge_roll_timer = DODGE_DURATION
	can_take_damage = false
	
	$Sprite2D/RollAnim.speed_scale = 1.0 / DODGE_DURATION
	$Sprite2D/RollAnim.play("roll_left_ccw_2" if direction.x < 0 else "roll_right_cw")

func _dodge_logic(delta: float) -> void:
	var elapsed_percent = 1.0 - (dodge_roll_timer / DODGE_DURATION)
	var current_speed = lerp(DODGE_SPEED, DODGE_SPEED * 0.5, elapsed_percent)
	
	dodge_roll_timer -= delta
	
	if dodge_roll_timer <= 0.0:
		dodge_roll_dir = Vector2.ZERO
		can_take_damage = true
