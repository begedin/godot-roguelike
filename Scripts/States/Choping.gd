extends 'Base.gd'

export var energy_cost = 5
onready var __sample_player = self.get_node('/root/Game/SamplePlayer')

var __time
var __time_total

func _ready():
	pass
	
func enter(entity):
	entity.set_process_input(false)
	entity.set_fixed_process(true)
	self.__sample_player.play('chop%02d' % int(rand_range(1, 3)))
	var animation = 'chop'
	entity.play(animation)
	var sprite_frames = entity.get_sprite_frames()
	var frame_count = sprite_frames.get_frame_count(animation)
	var animation_speed = sprite_frames.get_animation_speed(animation)
	self.__time = 0
	self.__time_total = frame_count/animation_speed
	
func update(entity, delta_time):
	self.__time += delta_time
	if self.__time >= self.__time_total:
		if entity.is_in_group('player'):
			entity.energy -= self.energy_cost
		entity.transition_to(self.__parent.get_node('Inactive'))
