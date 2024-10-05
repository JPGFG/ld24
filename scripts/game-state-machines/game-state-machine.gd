class_name GameStateMachine
extends Node


@export var initial_state = NodePath()
@onready var current_state: GameStateBase = get_node(initial_state)

func _ready():
	var children = get_children() as Array[GameStateBase]
	for child in children:
		child.state_machine = self
		
	current_state.enter.call_deferred()


func _physics_process(delta: float):
	current_state.state_physics_process(delta)

func _process(delta: float):
	current_state.state_process(delta)
	
func switch_to(target_state: String):
	if target_state == current_state.name:
		return
	if !has_node(target_state):
		print("could not find target state node: ", target_state)
		return
	current_state.exit()
	current_state = get_node(target_state)
	current_state.enter()
