extends KinematicBody2D


enum States { IDLE, FOLLOW }

const MASS = 10.0
const ARRIVE_DISTANCE = 10.0

export(float) var speed = 130.0
var _state = States.IDLE

var _path = []
var _target_point_world = Vector2()
var _target_position = Vector2()

var _velocity = Vector2()


func _ready():
	_change_state(States.IDLE)
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)

func _process(_delta):
	if _state != States.FOLLOW:
		return
	var _arrived_to_next_point = _move_to(_target_point_world)
	if _arrived_to_next_point:
		_path.remove(0)
		if len(_path) == 0:
			_change_state(States.IDLE)
			return
		_target_point_world = _path[0]


var timer
func _init():
	timer =Timer.new()
	add_child(timer)
	timer.wait_time = 10.0 
	timer.autostart = true
	timer.connect("timeout",self,"terminarT")


var f = false
func terminarT():
	timer.stop()
	f = true
	
func _unhandled_input(event):
	
	if f:
		var Player = get_parent().get_node("Limon").get_position()	
		if Input.is_key_pressed(KEY_SHIFT):
			global_position = Player
		else:
			_target_position = Player
		_change_state(States.FOLLOW)


func _move_to(world_position):
	position = get_parent().get_node("Lulo").get_position()
	var desired_velocity = (world_position - position).normalized() * speed
	var steering = desired_velocity - _velocity
	_velocity += steering / MASS
	position += _velocity * get_process_delta_time()
	rotation = _velocity.angle()
	return position.distance_to(world_position) < ARRIVE_DISTANCE


func _change_state(new_state):
	var Pos = get_parent().get_node("Lulo").get_position()
	if new_state == States.FOLLOW :
		_path = get_astar_path(Pos, _target_position)
		if not _path or len(_path) == 1:
			_change_state(States.IDLE)
			return
		# The index 0 is the starting cell.
		# We don't want the character to move back to it in this example.
		_target_point_world = _path[1]
	_state = new_state


















const BASE_LINE_WIDTH = 4.0
const DRAW_COLOR = Color.white

var path_start_position = Vector2() setget _set_path_start_position
var path_end_position = Vector2() setget _set_path_end_position

var _point_path = []

# You can only create an AStar node from code, not from the Scene tab.
onready var astar_node = AStar.new()
# get_used_cells_by_id is a method from the TileMap node.
# Here the id 0 corresponds to the grey tile, the obstacles.
onready var obstacles = get_parent().get_node("TileMap").get_used_cells_by_id(5)
onready var _half_cell_size = get_parent().get_node("TileMap").cell_size /2



	





# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles.
func astar_add_walkable_cells(obstacle_list = []):
	var points_array = []
	for y in range(get_parent().get_node("TileMap").map_size.y):
		for x in range(get_parent().get_node("TileMap").map_size.x):
			var point = Vector2(x, y)
			if point in obstacle_list:
				continue

			points_array.append(point)
			# The AStar class references points with indices.
			# Using a function to calculate the index from a point's coordinates
			# ensures we always get the same index with the same input point.
			var point_index = calculate_point_index(point)
			# AStar works for both 2d and 3d, so we have to convert the point
			# coordinates from and to Vector3s.
			astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array


# Once you added all points to the AStar node, you've got to connect them.
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like.
# It's a little harder to code at first, but works for 2d, 3d,
# orthogonal grids, hex grids, tower defense games...
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstalce.
		# We connect the current point with it.
		var points_relative = PoolVector2Array([
			point + Vector2.RIGHT,
			point + Vector2.LEFT,
			point + Vector2.DOWN,
			point + Vector2.UP,
		])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)
			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			# Note the 3rd argument. It tells the astar_node that we want the
			# connection to be bilateral: from point A to B and B to A.
			# If you set this value to false, it becomes a one-way path.
			# As we loop through all points we can set it to false.
			astar_node.connect_points(point_index, point_relative_index, true)


# This is a variation of the method above.
# It connects cells horizontally, vertically AND diagonally.


func calculate_point_index(point):
	return point.x + get_parent().get_node("TileMap").map_size.x * point.y 



func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= get_parent().get_node("TileMap").map_size.x or point.y >= get_parent().get_node("TileMap").map_size.y


func get_astar_path(world_start, world_end):
	self.path_start_position = get_parent().get_node("TileMap").world_to_map(world_start)
	self.path_end_position = get_parent().get_node("TileMap").world_to_map(world_end)
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = get_parent().get_node("TileMap").map_to_world(Vector2(point.x, point.y)) + _half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path():
	
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	# This method gives us an array of points. Note you need the start and
	# end points' indices as input.
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	# Redraw the lines and circles from the start to the end point.
	update()


# Setters for the start and end path values.
func _set_path_start_position(value):
	
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	get_parent().get_node("TileMap").set_cell(path_start_position.x, path_start_position.y, -1)
	get_parent().get_node("TileMap").set_cell(value.x, value.y, -1)
	path_start_position = value
	if path_end_position  != path_start_position:
		_recalculate_path()


func _set_path_end_position(value):
	 
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	get_parent().get_node("TileMap").set_cell(path_start_position.x, path_start_position.y, -1)
	get_parent().get_node("TileMap").set_cell(value.x, value.y, 2)
	path_end_position = value
	if path_start_position != value:
		_recalculate_path()

