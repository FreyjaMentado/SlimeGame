extends Node2D

func _ready():
	$Ground/TileMap/StartMessage.show()
	$Ground/TileMap/MessageTimer.start()

func _physics_process(_delta):
	var formattedTime = floatToMinutesSeconds($EndGame.time_left)
	$CanvasLayer/Timer.text = formattedTime

func _on_end_game_timeout():
	end_game()

func _on_area_2d_body_entered(_body):
	end_game()

func _on_message_timer_timeout():
	$Ground/TileMap/StartMessage.hide()

func floatToMinutesSeconds(timeInSeconds: float) -> String:
	var minutes = int(timeInSeconds / 60)
	var seconds = int(timeInSeconds) % 60
	
	# Convert to strings and ensure leading zeros if needed
	var minutesStr = str(minutes).pad_zeros(2)
	var secondsStr = str(seconds).pad_zeros(2)
	
	return minutesStr + ":" + secondsStr

func end_game():
	var game_vars = get_node("/root/GameVariables")
	game_vars.score = get_tree().get_nodes_in_group("Slime").size()
	SceneSwitcher.switch_scene("res://screens/endScreen/score_menu.tscn")


