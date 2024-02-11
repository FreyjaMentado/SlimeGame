class_name Player
extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var animations = $AnimationPlayer
@onready var coyote_jump_timer = $Timers/CoyoteJumpTimer
@onready var jump_buffer_timer = $Timers/JumpBuffer
@onready var sprite = $Sprite

@onready var slime_left_area = $LeftSlimeArea
@onready var slime_right_area = $RightSlimeArea
@onready var slime_bottom_left_area = $BottomLeftSlimeArea
@onready var slime_bottom_right_area = $BottomRightSlimeArea

@export var movement_data: PlayerMovementData
@export var slime_trail : PackedScene
@export var slime_trail_left : PackedScene
@export var slime_trail_right : PackedScene

enum side {
	left,
	right,
	bottom
}

# Reference to the two tilesets
var input_axis
var double_jump = false
var level

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
	handle_double_jump()
	handle_slime_trail()
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func handle_double_jump():
	if is_on_floor():
		double_jump = true

func handle_sprite():
	sprite.flip_h = input_axis > 0

func handle_slime_trail():
	if is_on_wall():
		var wall_normal = get_wall_normal()
		if wall_normal.x < 0:
			if !slime_left_area.is_colliding() and !slime_bottom_left_area.is_colliding():
				handle_spawn_slime(side.left)
		if wall_normal.x > 0:
			if !slime_right_area.is_colliding() and !slime_bottom_right_area.is_colliding():
				handle_spawn_slime(side.right)
	
	if is_on_floor():
		if !slime_bottom_left_area.is_colliding() and !slime_bottom_right_area.is_colliding():
			handle_spawn_slime(side.bottom)

func handle_spawn_slime(side_to_spawn: side):
	var slime
	match side_to_spawn:
		side.left:
			slime = slime_trail_left.instantiate()
		side.right:
			slime = slime_trail_right.instantiate()
		side.bottom:
			slime = slime_trail.instantiate()
	slime.transform = global_transform
	level.add_child(slime)
