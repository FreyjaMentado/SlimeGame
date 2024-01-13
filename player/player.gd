class_name Player
extends CharacterBody2D

@onready var state_machine = $StateMachine
@export var movement_data: PlayerMovementData

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)


#@export var movement_data : PlayerMovementData
#@onready var coyote_jump_timer = $CoyoteJumpTimer
#@onready var jump_buffer_timer = $JumpBuffer
#
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var double_jump = false
#var wall_slide = false
#var is_ground_pound = false

#func _physics_process(delta):
	##TODO: Break out each function into its own state
	#
	#handle_ground_pound()
	#
	#if not is_ground_pound:
		#apply_gravity(delta)
		#handle_jump()
		#handle_wall_jump()
		#
		#var input_axis = Input.get_axis("ui_left", "ui_right")
		#apply_friction(input_axis, delta)
		#apply_air_resistance(input_axis, delta)
		#handle_acceleration(input_axis, delta)
		#handle_air_acceleration(input_axis, delta)
		#handle_wall_slide(input_axis, delta)
	#
	#var was_on_floor = is_on_floor()
	#move_and_slide()
	#handle_coyote_jump(was_on_floor)
#
#func apply_gravity(delta):
	#if not is_on_floor() and not wall_slide:
		#velocity.y += gravity * delta * movement_data.gravity_scale
#
#func handle_jump():
	#if is_on_floor(): double_jump = true
	#
	#if is_on_floor() or coyote_jump_timer.time_left > 0.0 :
		#if Input.is_action_just_pressed("ui_accept") or jump_buffer_timer.time_left > 0.0:
			#print("base jump")
			#print("on floor: ", is_on_floor())
			#jump_buffer_timer.stop()
			#velocity.y = movement_data.jump_velocity
	#if not is_on_floor():
		#if Input.is_action_just_released("ui_accept") and velocity.y < movement_data.jump_velocity/2:
			#velocity.y = movement_data.jump_velocity/2
		#
		#if Input.is_action_just_pressed("ui_accept") and double_jump and not is_on_wall():
			#print("double jump")
			#velocity.y = movement_data.jump_velocity * 0.8
			#double_jump = false
#
#func handle_coyote_jump(was_on_floor):
	#var just_left_ground = was_on_floor and not is_on_floor() and velocity.y >= 0
	#if just_left_ground:
		#coyote_jump_timer.start()
#
#func handle_jump_buffer():
	#if Input.is_action_just_pressed("ui_accept"):
		#jump_buffer_timer.start()
#
#func apply_friction(input_axis, delta):
	#if input_axis == 0 and is_on_floor():
		#velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
#
#func apply_air_resistance(input_axis, delta):
	#if input_axis == 0 and not is_on_floor():
		#velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)
#
#func handle_acceleration(input_axis, delta):
	#if not is_on_floor(): return
	#if input_axis != 0:
		#velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.acceleration * delta)
#
#func handle_air_acceleration(input_axis, delta):
	#if is_on_floor(): return
	#if input_axis != 0:
		#velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.air_acceleration * delta)
#
#func handle_wall_jump():
	#if is_on_wall():
		#var wall_normal = get_wall_normal()
		#if Input.is_action_just_pressed("ui_accept"):
			#velocity.x = wall_normal.x * movement_data.speed
			#velocity.y = movement_data.jump_velocity
#
#func handle_wall_slide(input_axis, delta):
	#if not is_on_wall() or (is_on_wall() and input_axis == 0):
		#wall_slide = false
		#return
#
	#if is_on_wall() and input_axis != 0:
		#var wall_normal = get_wall_normal()
		#if input_axis != wall_normal.x:
			#wall_slide = true
			#velocity.y += gravity * delta * movement_data.wall_slide_speed
			#velocity.y = min(velocity.y, movement_data.max_wall_slide_speed)
			## line below is used to make it so that you dont slide up a wall if you start will climbing it while jumping up
			## TODO: currently breaks wall jump upward velocity if you are holding towards the wall
			##velocity.y = max(velocity.y, Vector2.ZERO.y)
		#else:
			#wall_slide = false
#
#func handle_ground_pound():
	#if Input.is_action_just_pressed("ground_pound") and not is_on_floor():
		#if movement_data.ground_pound and not is_ground_pound:
			#is_ground_pound = true
			#velocity = Vector2.ZERO
			#$AnimationPlayer.play("GroundPoundInit")
	#
	#if is_on_floor() and is_ground_pound:
		#$AnimationPlayer.play("GroundPoundLand")
#
#func move_ground_pound():
	#velocity = Vector2(0, movement_data.ground_pound_speed)
#
#func end_ground_pound():
	#is_ground_pound = false
