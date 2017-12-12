extends Node

var __enemy_turn_skip = false

onready var __actors = self.get_node('Board/Actors')
onready var __board = self.get_node('Board')

export var window_zoom = 1
	
func _ready():
	randomize()
	self.__board.fetch_tiles('res://Scenes/TileSet.tscn', 'Exit')
	self.__board.make_board()
	self.__init_ui()
	self.__set_screen()
	self.start()
	
func start():
	while true:	
		var actors = self.__actors.get_children()
		actors.invert()
		for actor in actors:
			if weakref(actor).get_ref() and (actor.is_in_group('player') or (actor.is_in_group('enemy') and not self.__enemy_turn_skip)):
				actor.activate()
				yield(actor, 'turn_end')
		self.__enemy_turn_skip = not self.__enemy_turn_skip

func __init_ui(): 
	var player = self.get_node('Board/Actors/Player')
	var health = self.get_node('UI/Health')
	health.hookup(player)

func __set_screen():
	var grid_size = (2 * (self.__board.perim_thickness + Vector2(1, 1)) + self.__board.inner_grid_size)
	var board_size = grid_size * self.__board.tile_collection.tile_size
	
	var stretch_mode = SceneTree.STRETCH_MODE_2D
	var aspect_mode = SceneTree.STRETCH_ASPECT_KEEP
	
	self.get_tree().set_screen_stretch(stretch_mode, aspect_mode, board_size)
	
	OS.set_window_size(self.window_zoom * board_size)
	
