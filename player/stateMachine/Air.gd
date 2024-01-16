extends State

@export var idle_state: State
@export var run_state: State
@export var ground_pound_state: State

@onready var coyote_jump_timer = $"../../Timers/CoyoteJumpTimer"
@onready var jump_buffer_timer = $"../../Timers/JumpBuffer"

var double_jump = false
var jump = false

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta * player.movement_data.gravity_scale
	
	if player.is_on_floor(): 
		jump = true
		double_jump = true
	
	if Input.is_action_just_pressed("jump") and jump_buffer_timer.time_left == 0.0:
		jump_buffer_timer.start()
	
	if (player.is_on_floor() or coyote_jump_timer.time_left > 0.0) and jump:
		if Input.is_action_just_pressed("jump") or jump_buffer_timer.time_left > 0.0:
			player.velocity.y = player.movement_data.jump_velocity
			jump_buffer_timer.stop()
			jump = false
	
	if not player.is_on_floor():
		if Input.is_action_just_released("jump") and player.velocity.y < player.movement_data.jump_velocity/2:
			player.velocity.y = player.movement_data.jump_velocity/2
		
		if Input.is_action_just_pressed("jump") and double_jump and not player.is_on_wall():
			player.velocity.y = player.movement_data.jump_velocity * 0.8
			double_jump = false
		
		if player.is_on_wall():
			var wall_normal = player.get_wall_normal()
			if Input.is_action_just_pressed("jump"):
				player.velocity.x = wall_normal.x * player.movement_data.speed
				player.velocity.y = player.movement_data.jump_velocity
	
	
	var input_axis = Input.get_axis('move_left', 'move_right')
	if input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, input_axis * player.movement_data.speed, player.movement_data.air_acceleration * delta)
	player.move_and_slide()
	
	if !player.is_on_floor() and Input.is_action_just_pressed("ground_pound"):
		return ground_pound_state
	
	if player.is_on_floor() and !Input.is_action_just_pressed("jump"):
		if input_axis != 0:
			return run_state
		return idle_state
	
	return null
