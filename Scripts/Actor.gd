extends AnimatedSprite

signal turn_end
signal energy_change

const UNIT_RIGHT = Vector2(1, 0)
const UNIT_DOWN = Vector2(0, 1)
const UNIT_LEFT = Vector2(-1, 0)
const UNIT_UP = Vector2(0, -1)

onready var ray_casts = {
	UNIT_RIGHT: self.get_node('RayCast2DRight'),
	UNIT_DOWN: self.get_node('RayCast2DDown'),
	UNIT_LEFT: self.get_node('RayCast2DLeft'),
	UNIT_UP: self.get_node('RayCast2DUp')
}

export (int) var energy = 100 setget _set_energy
export var damage = 1

onready var __area = self.get_node('Area2D')
onready var __states = self.get_node('/root/Game/States')

var __state

func transition_to(state):
	self.__state = state
	self.__state.enter(self)
	
func activate():
	var state_name = self.__idle_state()
	self.transition_to(self.__states.get_node(state_name))

func __idle_state():
	if self.is_in_group('player'):
		return 'IdlePlayer'
	elif self.is_in_group('enemy'):
		return 'IdleEnemy'
	
	
func _ready():
	if self.is_in_group('player') and Globals.has('player_energy'):
		self.energy = Globals.get('player_energy')
	for key in self.ray_casts:
		self.ray_casts[key].add_exception(self.__area)

func _input(event):
	self.__state.input(self, event)

func _fixed_process(delta_time):
	self.__state.update(self, delta_time)

func _set_energy(value):
	energy = value
	emit_signal('energy_change', self)
