extends State

@export var idle_state: State
@export var air_state: State

@onready var coyote_jump_timer = $"../../Timers/CoyoteJumpTimer"
@onready var jump_buffer_timer = $"../../Timers/JumpBuffer"

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	var input_axis = Input.get_axis('move_left', 'move_right')
	
	if input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, input_axis * player.movement_data.speed, player.movement_data.acceleration * delta)
	player.move_and_slide()
	
	if player.is_on_floor() and Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
		return air_state
		
	if !player.is_on_floor():
		coyote_jump_timer.start()
		return air_state
		
	if player.is_on_floor() and input_axis == 0:
		return idle_state
	
	return null
