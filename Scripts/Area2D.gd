extends Area2D

export var scale = 1.0

onready var parent = self.get_node('..')

onready var __board = self.get_node('/root/Game/Board')
onready var __actors = self.__board.get_node('Actors')
onready var __sample_player = self.get_node('/root/Game/SamplePlayer')

func take_damage(damage):
	self.__sample_player.play('enemy%02d' % int(rand_range(1, 3)))
	self.parent.energy -= damage
	if self.parent.is_in_group('enemy') and self.parent.energy <= 0:
		self.parent.queue_free()

func _ready():
	self.__set_shape()
	
func __set_shape():
	var dimension = self.__board.tile_collection.tile_size * 0.5
	self.set_pos(dimension)
	self.get_node('CollisionShape2D').get_shape().set_extents(dimension * scale)