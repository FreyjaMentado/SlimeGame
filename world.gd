extends Node2D

@onready var player = $Player

@export var slime_trail : PackedScene
@export var slime_trail_left : PackedScene
@export var slime_trail_right : PackedScene

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
	slime_left_area = player.get_node("LeftSlimeArea")
	slime_right_area = player.get_node("RightSlimeArea")
	slime_bottom_left_area = player.get_node("BottomLeftSlimeArea")
	slime_bottom_right_area = player.get_node("BottomRightSlimeArea")

func _physics_process(delta):
	handle_slime_trail()

func handle_slime_trail():
	if player.is_on_wall():
		var wall_normal = player.get_wall_normal()
		if wall_normal.x < 0:
			if !slime_left_area.is_colliding() and !slime_bottom_left_area.is_colliding():
				handle_spawn_slime(side.left)
		if wall_normal.x > 0:
			if !slime_right_area.is_colliding() and !slime_bottom_right_area.is_colliding():
				handle_spawn_slime(side.right)
	
	if player.is_on_floor():
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
	slime.transform = player.global_transform
	add_child(slime)


func _on_end_game_timeout():
	print("Game over!")
	print("Score: ", get_tree().get_nodes_in_group("Slime").size())
	get_tree().change_scene_to_file("res://score_menu.tscn")
