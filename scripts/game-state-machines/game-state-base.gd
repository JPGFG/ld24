class_name GameStateBase
extends Node

var state_machine

func enter():
	print("Entered: ")
	pass

func exit():
	pass

func state_activity():
	pass

func state_process(delta):
	pass

func state_physics_process(delta):
	pass

func show_info():
	print(name, "/", state_machine)
