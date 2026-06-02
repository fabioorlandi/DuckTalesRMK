extends Node

@export var initial_state: State

var states: Dictionary = {}
var current_state: State
var label_state: Label

func _ready() -> void:
	label_state = get_parent().get_node("Label_State")
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		label_state.text = current_state.name.to_lower()
		
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name)
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
		current_state = new_state
		current_state.enter()
	if label_state:
		label_state.text = new_state_name
