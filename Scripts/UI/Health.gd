extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func hookup(player):
	self.set_text('Health: %s' % player.energy)
	player.connect('energy_change', self, '__on_energy_changed')
	
	
func __on_energy_changed(player):
	self.set_text('Health: %s' % player.energy)
