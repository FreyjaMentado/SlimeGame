extends Control

@export var level:PackedScene

func _on_play_pressed():
	SceneSwitcher.switch_scene("res://levels/world/world.tscn")

func _on_quit_pressed():
	get_tree().quit()
