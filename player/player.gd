class_name Player
extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var animations = $AnimationPlayer
@onready var coyote_jump_timer = $Timers/CoyoteJumpTimer
@onready var jump_buffer_timer = $Timers/JumpBuffer
@onready var sprite = $Sprite
@onready var slime_left = $LeftSlime
@onready var slime_right = $RightSlime
@onready var slime_bottom = $BottomSlime

@export var movement_data: PlayerMovementData
@export var slime_trail: PackedScene

# Reference to the two tilesets
var input_axis
var spawn_slime

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	sprite.scale.x = 0.347
	sprite.scale.y = 0.347
	sprite.position.y += 1
	z_index = 10
	spawn_slime = true

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	input_axis = Input.get_axis('move_left', 'move_right')
	sprite.flip_h = input_axis > 0
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)



