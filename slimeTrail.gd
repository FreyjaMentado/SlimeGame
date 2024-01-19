extends Node2D

func _on_area_2d_body_entered(body):
	body.spawn_slime = false

func _on_area_2d_body_exited(body):
	body.spawn_slime = true
