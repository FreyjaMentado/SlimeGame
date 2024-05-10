extends Node2D

@onready var start_message = $Ground/TileMap/StartMessage
@onready var score_timer = $Timers/ScoreTimer
@onready var minutes_label = $CanvasLayer/Minutes
@onready var seconds_label = $CanvasLayer/Seconds

func _physics_process(delta):
	var minutes = int(score_timer.time_left) / 60
	var seconds = int(score_timer.time_left) % 60
	minutes_label.text = str(minutes)
	seconds_label.text = str(seconds)

func _on_score_timer_timeout():
	SceneSwitcher.switch_scene("res://screens/endScreen/score_menu.tscn")

func _on_message_timer_timeout():
	start_message.visible = false
