extends State

@export var idle_state: State
@export var run_state: State
@export var air_state: State

var is_ground_pound = false

func enter() -> void:
	super()
	is_ground_pound = false

func process_physics(delta: float) -> State:
	if !player.is_on_floor() and player.movement_data.ground_pound and !is_ground_pound:
		is_ground_pound = true
		player.velocity = Vector2.ZERO
		player.animations.play("GroundPoundInit")
	
	if player.is_on_floor() and is_ground_pound:
		player.animations.play("GroundPoundLand")
	
	player.move_and_slide()
	
	if !is_ground_pound:
		var input_axis = Input.get_axis('move_left', 'move_right')
		if input_axis != 0:
			return run_state
		if Input.is_action_just_pressed("jump"):
			return air_state
		else:
			return idle_state
	
	return null

func move_ground_pound():
	player.velocity = Vector2(0, player.movement_data.ground_pound_speed)

func end_ground_pound():
	is_ground_pound = false