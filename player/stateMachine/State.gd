class_name State
extends Node

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Hold a reference to the player so that it can be controlled by the state
var player: CharacterBody2D

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
