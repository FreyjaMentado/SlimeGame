class_name Player
extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var animations = $AnimationPlayer
@onready var coyote_jump_timer = $Timers/CoyoteJumpTimer
@onready var jump_buffer_timer = $Timers/JumpBuffer
@onready var slime_dash_timer = $Timers/SlimeDashTimer
@onready var sprite = $Sprite
@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var left_floor_slime = $LeftFloorSlime
@onready var right_floor_slime = $RightFloorSlime
@onready var left_wall_slime = $LeftWallSlime
@onready var right_wall_slime = $RightWallSlime

@export var movement_data: PlayerMovementData
@export var slime_trail_collision: PackedScene
@export var slime_blob: PackedScene

# Reference to the two tilesets
var input_axis
var level
var double_jump:bool = false
var spawning_slime:bool = false
var current_slime:Line2D = null
var on_wall: bool = false
var sprite_locked: bool = false

enum side {
	left_floor,
	right_floor,
	left_wall,
	right_wall,
	none
}

func _ready() -> void:
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
	on_wall = is_player_on_wall()
	is_spawning_slime()
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func handle_double_jump():
	if is_on_floor():
		double_jump = true

func handle_sprite():
	if input_axis != 0:
		sprite_locked = false
	else:
		sprite_locked = true
	if !sprite_locked:
		sprite.flip_h = input_axis > 0

func is_player_on_wall() -> bool:
	if left_wall.is_colliding() or right_wall.is_colliding():
		return true
	return false

func is_spawning_slime() -> bool:
	if !is_on_floor() and !on_wall:
		if spawning_slime:
			spawning_slime = false
			current_slime = null
			return false
	return true

func handle_slime_trail():
	if !is_spawning_slime():
		return

	var spawn_side = handle_spawn_side()
	if spawn_side == side.none:
		return
	
	handle_should_spawn_point(spawn_side)

func handle_spawn_side():
	if is_on_floor():
		if velocity.x > 0:
			return side.left_floor
		elif velocity.x < 0:
			return side.right_floor
	elif on_wall:
		var wall_normal = get_wall_normal()
		if wall_normal.x > 0:
			return side.left_wall
		elif wall_normal.x < 0:
			return side.right_wall
	return side.none

func handle_should_spawn_point(spawn_side):
	match spawn_side:
		side.left_floor:
			if !left_floor_slime.has_overlapping_areas() and !right_floor_slime.has_overlapping_areas():
				handle_spawn_point(spawn_side, true)
			elif !left_floor_slime.has_overlapping_areas() and right_floor_slime.has_overlapping_areas():
				handle_spawn_point(side.right_floor, false)
		side.right_floor:
			if !left_floor_slime.has_overlapping_areas() and !right_floor_slime.has_overlapping_areas():
				handle_spawn_point(spawn_side, true)
			elif !right_floor_slime.has_overlapping_areas() and left_floor_slime.has_overlapping_areas():
				handle_spawn_point(side.left_floor, false)
		side.left_wall:
			if !left_wall_slime.has_overlapping_areas() and !left_floor_slime.has_overlapping_areas():
				handle_spawn_point(spawn_side, true)
			elif !left_wall_slime.has_overlapping_areas() and left_floor_slime.has_overlapping_areas():
				handle_spawn_point(side.left_floor, false)
		side.right_wall:
			if !right_wall_slime.has_overlapping_areas() and !right_floor_slime.has_overlapping_areas():
				handle_spawn_point(spawn_side, true)
			elif !right_wall_slime.has_overlapping_areas() and right_floor_slime.has_overlapping_areas():
				handle_spawn_point(side.right_floor, false)

func handle_spawn_point(spawn_side, add_collider):
	if !spawning_slime:
		start_slime_line()
		current_slime.add_point(get_spawn_position(spawn_side))
	elif spawning_slime:
		current_slime.add_point(get_spawn_position(spawn_side))
	if add_collider:
		handle_collision(get_spawn_position(spawn_side))

func start_slime_line():
	spawning_slime = true
	current_slime = Line2D.new()
	current_slime.z_index = 9
	current_slime.default_color = Color(0.5, 0.8, 0.2, 1.0) 
	current_slime.width = 8
	level.add_child(current_slime)

func get_spawn_position(spawn_side):
	var spawn_position = position
	match spawn_side:
		side.left_floor:
			spawn_position = left_floor_slime.global_position
			spawn_position.y += 5
		side.right_floor:
			spawn_position = right_floor_slime.global_position
			spawn_position.y += 5
		side.left_wall:
			spawn_position = left_wall_slime.global_position
			spawn_position.x -= 5
		side.right_wall:
			spawn_position = right_wall_slime.global_position
			spawn_position.x += 5
	return spawn_position

func handle_collision(spawn_position):
	var collider
	collider = slime_trail_collision.instantiate()
	collider.position = spawn_position
	level.add_child(collider)

func handle_launch_slime():
	var slime
	# TODO: Need to spawn multiples and send in both directions and probably add a check
	#       for ground pound vs double jump
	slime = slime_blob.instantiate()
	slime.position = global_position
	level.add_child(slime)
	slime.connect("slime_landed", handle_slime_blob)
	slime.apply_central_impulse(Vector2(-200,-200))
	# slime.apply_central_impulse(Vector2(200,-200)) # Launches to the right
	# slime.apply_central_impulse(Vector2(-400,-400)) # Launches to the left further and higher
	# slime.apply_central_impulse(Vector2(400,-400)) # Launches to the right further and higher

func handle_slime_blob(slime_blob, spawn_side):
	start_slime_line()
	current_slime.add_point(slime_blob.global_position)
	var left = slime_blob.global_position
	left.x += 15
	var right = slime_blob.global_position
	right.x -= 15
	current_slime.add_point(left)
	current_slime.add_point(right)
	current_slime = null
	slime_blob.queue_free()
