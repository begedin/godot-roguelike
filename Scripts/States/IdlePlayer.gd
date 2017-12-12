extends 'Base.gd'

func enter(entity):
	entity.set_fixed_process(false)
	entity.set_process_input(true)
	var animation = 'idle'
	entity.play(animation)
	
func input(entity, event):
	var delta_xy
	var moved = false
	if event.is_action_pressed('ui_right'):
		delta_xy = entity.UNIT_RIGHT
		moved = true
	elif event.is_action_pressed('ui_down'):
		delta_xy = entity.UNIT_DOWN
		moved = true
	elif event.is_action_pressed('ui_left'):
		delta_xy = entity.UNIT_LEFT
		moved = true
	elif event.is_action_pressed('ui_up'):
		delta_xy = entity.UNIT_UP
		moved = true

	if moved:
		var state = self.__parent.get_node('Moving')
		state.delta_xy = delta_xy
		entity.transition_to(state)		
		