extends Node2D

@onready var player = $Player

@export var slime_trail : PackedScene
@export var slime_trail_left : PackedScene
@export var slime_trail_right : PackedScene

var slime_left
var slime_right
var slime_bottom
var slime_left_area
var slime_right_area
var slime_bottom_left_area
var slime_bottom_right_area

enum side {
	left,
	right,
	bottom
}

func _ready():
	slime_left = player.get_node("LeftSlime")
	slime_right = player.get_node("RightSlime")
	slime_bottom = player.get_node("BottomSlime")
	slime_left_area = player.get_node("LeftSlimeArea")
	slime_right_area = player.get_node("RightSlimeArea")
	slime_bottom_left_area = player.get_node("BottomLeftSlimeArea")
	slime_bottom_right_area = player.get_node("BottomRightSlimeArea")

func _physics_process(delta):
	handle_slime_trail()

func handle_slime_trail():
	var collider_object : Object
	
	if slime_left.is_colliding():
		if !slime_left_area.is_colliding() and !slime_bottom_left_area.is_colliding():
			print("spawn")
			handle_spawn_slime(side.left)
	
	if slime_right.is_colliding():
		if !slime_right_area.is_colliding() and !slime_bottom_right_area.is_colliding():
			print("spawn")
			handle_spawn_slime(side.right)
	
	if slime_bottom.is_colliding():
		if !slime_bottom_left_area.is_colliding() and !slime_bottom_right_area.is_colliding():
			print("spawn")
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
	slime.transform = player.global_transform
	add_child(slime)
