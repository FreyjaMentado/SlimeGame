extends State

@export var idle_state: State
@export var air_state: State
@export var run_state: State

@onready var slime_bottom_left_area = $"../../BottomLeftSlimeArea"
@onready var slime_bottom_right_area = $"../../BottomRightSlimeArea"

func enter() -> void:
	super()
	player.velocity.x = player.movement_data.dash_velocity * player.input_axis

func process_physics(delta: float) -> State:
	handle_movement(delta)
	handle_friction(delta)
	
	player.move_and_slide()
	
	return handle_state()

func handle_movement(delta):
	if player.input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, player.input_axis * player.movement_data.speed, player.movement_data.acceleration * delta)

func handle_friction(delta):
	player.velocity.x = move_toward(player.velocity.x, 0, player.movement_data.slime_resistance * delta)

func handle_state():
	if player.is_on_floor() and player.slime_side == player.side.none:
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
