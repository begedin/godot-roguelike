extends 'Base.gd'

export var duration = 0.25
export var energy_cost = 5
var __time_elapsed = 0
var __pos_start
var delta_xy

onready var __board = self.get_node('/root/Game/Board')
onready var __sample_player = self.get_node('/root/Game/SamplePlayer')

func enter(entity):
	entity.set_process_input(false)
	entity.set_fixed_process(true)
	self.__time_elapsed = 0
	self.__pos_start = entity.get_pos()
	if entity.ray_casts[delta_xy].is_colliding():
		var collider = entity.ray_casts[delta_xy].get_collider()
		var state_name
		if self.__attack_occured(entity, collider):
			collider.take_damage(entity.damage)
			state_name = 'Choping'
		elif entity.is_in_group('player'):
			state_name = 'IdlePlayer'
		elif entity.is_in_group('enemy'):
			self.delta_xy = Vector2(0, 0)
		if state_name:
			entity.transition_to(self.__parent.get_node(state_name))
	else:
		self.__sample_player.play('footsteps%02d' % int(rand_range(1, 3)))
		
func __attack_occured(entity, collider):
	return self.__player_swung_at_enemy_or_obstacle(entity, collider) or self.__enemy_swung_at_player_or_obstacle(entity, collider)

func __player_swung_at_enemy_or_obstacle(entity, collider):
	return (entity.is_in_group('player') and (collider.is_in_group('obstacle') or collider.parent.is_in_group('enemy')))

func __enemy_swung_at_player_or_obstacle(entity, collider):
	return (entity.is_in_group('enemy') and (collider.is_in_group('obstacle') or collider.parent.is_in_group('player')))

func update(entity, delta_time):
	var delta_xy_px = self.delta_xy * self.__board.tile_collection.tile_size
	var target_pos = self.__pos_start + delta_xy_px
	var move_progress = self.__time_elapsed/self.duration
	var pos = self.__pos_start.linear_interpolate(target_pos, move_progress)
	
	if self.__time_elapsed > self.duration:
		pos = self.__pos_start + delta_xy_px
		if entity.is_in_group('player'):
			entity.energy -= self.energy_cost
		entity.transition_to(self.__parent.get_node('Inactive'))
	
	self.__time_elapsed += delta_time
	entity.set_pos(pos)