extends State

@export var idle_state: State
@export var air_state: State
@export var slime_dash_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	handle_movement(delta)
	player.handle_slime_trail()
	player.move_and_slide()
	return handle_state()

func handle_movement(delta):
	if player.input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, player.input_axis * player.movement_data.speed, player.movement_data.acceleration * delta)

func handle_state():
	if player.is_on_floor() and player.input_axis == 0:
		return idle_state
	
	if Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer.start()
		return air_state

	if !player.is_on_floor():
		player.coyote_jump_timer.start()
		return air_state
	
	if Input.is_action_just_pressed("dash"):
		return slime_dash_state
	
	return null
