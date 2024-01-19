extends Node2D

@onready var player = $Player

@export var slime_trail : PackedScene

var slime_left
var slime_right
var slime_bottom

func _ready():
	slime_left = player.get_node("LeftSlime")
	slime_right = player.get_node("RightSlime")
	slime_bottom = player.get_node("BottomSlime")

func _physics_process(delta):
	handle_spawn_slime()

func handle_spawn_slime():
	if player.spawn_slime:
		if slime_left.is_colliding():
			var slime = slime_trail.instantiate()
			add_child(slime)
			slime.transform = player.global_transform
		
		if slime_right.is_colliding():
			var slime = slime_trail.instantiate()
			add_child(slime)
			slime.transform = player.global_transform
		
		if slime_bottom.is_colliding():
			var slime = slime_trail.instantiate()
			add_child(slime)
			slime.transform = player.global_transform
