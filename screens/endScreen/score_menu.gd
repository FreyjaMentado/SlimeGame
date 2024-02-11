extends Control

func _ready():
	var game_vars = get_node("/root/GameVariables")
	$MarginContainer/VBoxContainer/ScoreLabel.text = "Score: " + str(game_vars.score)

func _on_restart_pressed():
	SceneSwitcher.switch_scene("res://levels/world/world.tscn")

func _on_quit_pressed():
	get_tree().quit()
