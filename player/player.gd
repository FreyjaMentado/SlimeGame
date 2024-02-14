class_name Player
extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var animations = $AnimationPlayer
@onready var coyote_jump_timer = $Timers/CoyoteJumpTimer
@onready var jump_buffer_timer = $Timers/JumpBuffer
@onready var slime_dash_timer = $Timers/SlimeDashTimer
@onready var slime_spawn_timer = $Timers/SlimeSpawnTimer
@onready var sprite = $Sprite
@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall

@export var movement_data: PlayerMovementData

# Reference to the two tilesets
var input_axis
var level
var double_jump:bool = false
var spawning_slime:bool = false
var current_slime:Line2D = null
var on_wall: bool = false

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	sprite.scale.x = 0.347
	sprite.scale.y = 0.347
	sprite.position.y += 1
	z_index = 10
	level = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	input_axis = Input.get_axis('move_left', 'move_right')
	handle_sprite()
	handle_slime_trail()
	handle_double_jump()
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func handle_double_jump():
	if is_on_floor():
		double_jump = true

func handle_sprite():
	sprite.flip_h = input_axis > 0

func handle_slime_trail():
	if left_wall.is_colliding() or right_wall.is_colliding():
		on_wall = true
	else:
		on_wall = false
	
	if !is_on_floor() and !on_wall:
		if spawning_slime:
			spawning_slime = false
			current_slime = null
		return
	
	var offset_position = position
	if is_on_floor():
		offset_position.y += 5
	elif on_wall:
		var wall_normal = get_wall_normal()
		offset_position.x += 10 * (wall_normal.x * -1)
	
	handle_spawn_point(offset_position)

func handle_spawn_point(offset_position):
	if !spawning_slime:
		start_slime_line()
		add_point(offset_position)
	elif spawning_slime and slime_spawn_timer.time_left == 0.0:
		add_point(offset_position)

func start_slime_line():
	spawning_slime = true
	current_slime = Line2D.new()
	current_slime.z_index = 9
	current_slime.default_color = Color(0.5, 0.8, 0.2, 1.0) 
	current_slime.width = 8
	level.add_child(current_slime)

func add_point(offset_position):
	current_slime.add_point(offset_position)
	slime_spawn_timer.start()
