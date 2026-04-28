class_name NodeStateMachine
extends Node

@export var initial_state: NodeState

var states: Dictionary = {}
var current_state: NodeState
var current_state_name: String

func _ready() -> void:
	for child in get_children():
		if child is NodeState:
			states[child.name.to_lower()] = child
			child.transition.connect(Callable(self, "transition_to"))

	if initial_state:
		current_state = initial_state
		current_state_name = current_state.name.to_lower()
		current_state.enter()

# 🔥 Truyền sự kiện xuống State hiện tại
func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)
		current_state.check_transition()

func transition_to(state_name: String) -> void:
	if state_name == null || state_name.to_lower() == current_state_name:
		return

	var new_state: NodeState = states.get(state_name.to_lower())
	if new_state == null:
		return

	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
	current_state_name = state_name.to_lower()

	if current_state_name != "idle" and current_state_name != "walk":
		print("🚀 Action State:", current_state_name)
