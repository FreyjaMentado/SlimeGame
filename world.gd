extends Node2D

@onready var player = $Player

@export var slime_trail : PackedScene

var slime_left
var slime_right
var slime_bottom
var slime_left_area
var slime_right_area
var slime_bottom_left_area
var slime_bottom_right_area

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
		if slime_left_area.is_colliding():
			collider_object = slime_left_area.get_collider() 
			if !collider_object.is_class("Area2D"):
				handle_spawn_slime()
	
	if slime_right.is_colliding():
		handle_spawn_slime()
	
	if slime_bottom.is_colliding():
		if ((slime_bottom_left_area.is_colliding() and !slime_bottom_right_area.is_colliding())
		or (!slime_bottom_left_area.is_colliding() and slime_bottom_right_area.is_colliding())
		or (!slime_bottom_left_area.is_colliding() and !slime_bottom_right_area.is_colliding())):
			handle_spawn_slime()
		

func handle_spawn_slime():
	var slime = slime_trail.instantiate()
	add_child(slime)
	slime.transform = player.global_transform
