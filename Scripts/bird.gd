extends CharacterBody2D

class_name Bird

## Emitted when the game starts (bird begins falling)
signal game_started

@export var gravity: float = 900.0
@export var jump_force: int = -240
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const MAX_SPEED: int = 400
const ROTATION_SPEED: float = 2.0

var is_started: bool = false
var should_process_input: bool = true

func _ready() -> void:
	velocity = Vector2.ZERO
	animation_player.play("idle")
	# Start the game immediately
	is_started = true
	animation_player.play("flap_wings")
	game_started.emit()

func _physics_process(delta: float) -> void:
	if should_process_input and _is_flap_input():
		jump()
	if not is_started:
		return
	velocity.y += gravity * delta
	if velocity.y > MAX_SPEED:
		velocity.y = MAX_SPEED
	move_and_collide(velocity * delta)
	rotate_bird()

func _is_flap_input() -> bool:
	# Accept any key, mouse button, or screen touch
	return Input.is_anything_pressed()

func jump() -> void:
	velocity.y = jump_force
	rotation = deg_to_rad(-30)

func rotate_bird() -> void:
	# Rotate downwards when falling
	if velocity.y > 0 and rad_to_deg(rotation) < 90:
		rotation += ROTATION_SPEED * deg_to_rad(1)
	# Rotate upwards when rising
	elif velocity.y < 0 and rad_to_deg(rotation) > -30:
		rotation -= ROTATION_SPEED * deg_to_rad(1)

func kill() -> void:
	should_process_input = false

func stop() -> void:
	animation_player.stop()
	gravity = 0
	velocity = Vector2.ZERO
