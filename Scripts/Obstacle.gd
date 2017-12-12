extends 'Area2D.gd'

const SPRITE_PATH = 'res://Sprites/TileSet/%s%s.png'

export var sprite = ''
export var hp = 3

onready var __pos_start = self.parent.get_pos()

var __sprite_damage_set = false
var __time = 0
var __time_total = 0.1
var __amplitude = 3

func _ready():
	self.parent.get_texture().load(SPRITE_PATH % [self.sprite, ''])

func take_damage(damage):
	print('take damage')
	print(damage)
	self.set_process(true)
	self.__time = 0
	self.hp -= damage
	if self.hp <= 0:
		self.parent.queue_free()
	if not self.__sprite_damage_set:
		var texture_path = SPRITE_PATH % [self.sprite, '_dmg']
		print(texture_path)
		self.parent.set_texture(load(texture_path))
		
func _process(delta_time):
	self.__time += delta_time
	var rand_shake = Vector2(randf(), randf())
	var shake_amount = rand_shake * 2 * self.__amplitude - Vector2(1, 1) * self.__amplitude
	self.parent.set_pos(self.__pos_start + shake_amount)
	
	if self.__time >= self.__time_total:
		self.parent.set_pos(self.__pos_start)
		self.set_process(false)