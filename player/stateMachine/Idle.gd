extends State

@export var air_state: State
@export var run_state: State

@onready var coyote_jump_timer = $"../../Timers/CoyoteJumpTimer"
@onready var jump_buffer_timer = $"../../Timers/JumpBuffer"

func enter() -> void:
	super()
	player.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and player.is_on_floor():
		return air_state
	if Input.is_action_just_pressed('move_left') or Input.is_action_just_pressed('move_right'):
		return run_state
	return null

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	
	if player.is_on_floor() and Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
		return air_state
		
	if !player.is_on_floor():
		coyote_jump_timer.start()
		return air_state
	
	return null
