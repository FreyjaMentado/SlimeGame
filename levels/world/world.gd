extends Node2D

func _on_area_2d_body_entered(_body):
	var game_vars = get_node("/root/GameVariables")
	game_vars.score = get_tree().get_nodes_in_group("Slime").size()
	SceneSwitcher.switch_scene("res://screens/endScreen/score_menu.tscn")
