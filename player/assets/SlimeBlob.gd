extends RigidBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	player.slime_blob = true

func _on_area_2d_body_entered(body):
	player.start_slime_line()
	player.current_slime.add_point(global_position)
	var left = global_position
	left.x += 15
	var right = global_position
	left.x -= 15
	player.current_slime.add_point(left)
	player.current_slime.add_point(right)
	player.slime_blob = false
	queue_free()
