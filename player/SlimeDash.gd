extends State

@export var idle_state: State
@export var air_state: State
@export var run_state: State

func enter() -> void:
	super()
	player.slime_dash_timer.start()
	handle_dash()

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("dash") and player.slime_dash_timer.time_left == 0:
		handle_dash()
	handle_movement(delta)
	handle_friction(delta)
	
	player.handle_slime_trail()
	player.move_and_slide()
	
	return handle_state()

func handle_dash():
	if player.input_axis > 0:
		if player.right_floor_slime.has_overlapping_areas():
			start_dash()
	elif player.input_axis < 0:
		if player.left_floor_slime.has_overlapping_areas():
			start_dash()

func start_dash():
	player.slime_dash_timer.start()
	player.velocity.x = player.movement_data.dash_velocity * player.input_axis

func handle_movement(delta):
	if player.input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, player.input_axis * player.movement_data.speed, player.movement_data.slime_acceleration * delta)

func handle_friction(delta):
	player.velocity.x = move_toward(player.velocity.x, 0, player.movement_data.slime_resistance * delta)

func handle_state():
	if ((player.is_on_floor() and abs(player.velocity.x) <= player.movement_data.speed)
	or (!player.left_floor_slime.has_overlapping_areas() and !player.right_floor_slime.has_overlapping_areas())):
		if player.input_axis != 0:
			return run_state
		return idle_state
	
	if Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer.start()
		return air_state

	if !player.is_on_floor():
		player.coyote_jump_timer.start()
		return air_state
	
	return null
