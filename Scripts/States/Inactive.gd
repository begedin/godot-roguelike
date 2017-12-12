extends 'Base.gd'

func enter(entity):
	entity.set_fixed_process(false)
	entity.set_process_input(true)
	entity.play('idle')
	entity.emit_signal('turn_end')
		
	