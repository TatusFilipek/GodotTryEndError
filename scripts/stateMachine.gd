class_name StateMachine

var lastState: State
var state: State

func SwitchState(newState: State) -> void:
	state.exit()
	
	lastState = state
	state = newState
	
	state._init()

func PhysicsUpdate(delta) -> void:
	state.PhysicsUpdate(delta)
	
func Init(_state: State) -> void:
	lastState = _state
	state = _state
	
	state._init()
