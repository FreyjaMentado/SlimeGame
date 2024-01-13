extends State

@export var air_state: State
@export var run_state: State

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
	
	if !player.is_on_floor():
		return air_state
	return null
