extends 'Area2D.gd'

func _ready():
	self.connect('area_enter', self, '__on_area_enter')
	
func __on_area_enter(area):
	var entity = area.get_node('..')
	if entity.is_in_group('player'):
		entity.energy = Globals.get('player_energy')
		self.get_tree().reload_current_scene()