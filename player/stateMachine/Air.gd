extends State

@export var idle_state: State
@export var run_state: State

@onready var coyote_jump_timer = $"../../Timers/CoyoteJumpTimer"
@onready var jump_buffer_timer = $"../../Timers/JumpBuffer"

var double_jump = false

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	
	if player.is_on_floor(): double_jump = true
	
	if player.is_on_floor() or coyote_jump_timer.time_left > 0.0 :
		if Input.is_action_just_pressed("jump") or jump_buffer_timer.time_left > 0.0:
			jump_buffer_timer.stop()
			player.velocity.y = player.movement_data.jump_velocity
	if not player.is_on_floor():
		if Input.is_action_just_released("jump") and player.velocity.y < player.movement_data.jump_velocity/2:
			player.velocity.y = player.movement_data.jump_velocity/2
		
		if Input.is_action_just_pressed("jump") and double_jump and not player.is_on_wall():
			player.velocity.y = player.movement_data.jump_velocity * 0.8
			double_jump = false
	
	
	var input_axis = Input.get_axis('move_left', 'move_right')
	if input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, input_axis * player.movement_data.speed, player.movement_data.air_acceleration * delta)
	player.move_and_slide()
	
	if player.is_on_floor():
		if input_axis != 0:
			return run_state
		return idle_state
	
	return null
