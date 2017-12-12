extends Node

export var inner_grid_size = Vector2(8, 8)
export var perim_thickness = Vector2(1, 1)
export var count_obstacles = Vector2(2, 7)
export var count_items = Vector2(3, 6)
export var count_enemies = Vector2(2, 2)

onready var actors = self.get_node('Actors')

var tile_collection
var __grid

class TileCollection:
	var item = {}
	var tile_size
	
func __rand_tile(tile_set):
	var tiles = tile_set.get_children()
	var r = int(rand_range(0, tiles.size()))
	return tiles[r]
	
func __add_tile(tile, parent, gridxy):
	var tile_dup = tile.duplicate()
	var xy = (self.perim_thickness + Vector2(1, 1) +gridxy) * self.tile_collection.tile_size
	tile_dup.set_pos(xy)
	parent.add_child(tile_dup)
	
func __add_base_tiles():
	var bounds = {
		xmin = -self.perim_thickness.x -1, xmax = self.inner_grid_size.x + self.perim_thickness.x,
		ymin = -self.perim_thickness.y -1, ymax = self.inner_grid_size.y + self.perim_thickness.y
	}
	
	for x in range(bounds.xmin, bounds.xmax + 1):
		for y in range(bounds.ymin, bounds.ymax + 1):
			var tile
			if (x == bounds.xmin or x == bounds.xmax or y == bounds.ymin or y == bounds.ymax):
				tile = self.__rand_tile(self.tile_collection.item.walls)
			else:
				tile = self.__rand_tile(self.tile_collection.item.floors)
			self.__add_tile(tile, self, Vector2(x, y))
			
func __add_other_tiles(tile_set, parent, count=Vector2(1, 1)):
	var n = int(rand_range(count.x, count.y))
	
	for i in range(n):
		var index = int(rand_range(0, self.__grid.size()))
		var xy = self.__grid[index]
		var tile = self.__rand_tile(tile_set)
		self.__add_tile(tile, parent, xy)
		self.__grid.remove(index)
		
func __make_grid():
	var grid = []
	for x in range(self.inner_grid_size.x):
		for y in range(self.inner_grid_size.y):
			grid.push_back(Vector2(x, y))
	return grid

func make_board():
	randomize()
	
	self.__grid = __make_grid()
	
	self.__add_base_tiles()

	self.__add_other_tiles(self.tile_collection.item.obstacles, self, count_obstacles)
	self.__add_other_tiles(self.tile_collection.item.items, self, count_items)
	self.__add_other_tiles(self.tile_collection.item.enemies, self.actors, count_enemies)
	
	self.__add_tile(self.tile_collection.item.exit, self, Vector2(self.inner_grid_size.x, -1))
	self.__add_tile(self.tile_collection.item.player, self.actors, Vector2(-1, self.inner_grid_size.y))
	
func fetch_tiles(tile_set_filepath, size_node_name):
	self.tile_collection = TileCollection.new()
	var tile_set_scene = load(tile_set_filepath)
	var tile_set = tile_set_scene.instance()
	for node in tile_set.get_children():
		self.tile_collection.item[node.get_name().to_lower()] = node
	self.tile_collection.tile_size = (tile_set.get_node(size_node_name).get_texture().get_size())

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
