@tool
class_name PetriDish extends Node2D

@onready var northernWall: StaticBody2D = $NorthernWall
@onready var easternWall: StaticBody2D = $EasternWall
@onready var southernWall: StaticBody2D = $SouthernWall
@onready var westernWall: StaticBody2D = $WesternWall
@onready var areas: Node2D = $Areas

const AREA_SCENE: PackedScene = preload("res://scenes/dish_area/dish_area.tscn")

@export
var size: Vector2i = Vector2i(10, 10):
	set(value):
		size = Vector2i(
			clampi(value.x, 1, 50),
			clampi(value.y, 1, 50)
		)
		_update_walls()
		_update_areas()

@export_range(10e3, 10e4, 10e3)
var initial_energy_per_area: int = 10e5

func _ready() -> void:
	size = size

func _update_walls() -> void:
	_update_wall(northernWall, size.x, false, -1)
	_update_wall(southernWall, size.x, false, 1)
	_update_wall(easternWall, size.y, true, 1)
	_update_wall(westernWall, size.y, true, -1)
	
func _update_wall(
	wall: StaticBody2D,
	scale_value: int,
	move_on_horizontal_axis: bool,
	position_value: int
) -> void:
	if wall:
		wall.scale.x = scale_value
		if move_on_horizontal_axis:
			wall.position.x = size.x * position_value * Globals.HALF_AREA_SIZE
		else:
			wall.position.y = size.y * position_value * Globals.HALF_AREA_SIZE

func _update_areas() -> void:
	if areas:
		areas.position.x = (-size.x + 1) * Globals.HALF_AREA_SIZE
		areas.position.y = (-size.y + 1) * Globals.HALF_AREA_SIZE

		for child in areas.get_children():
			child.queue_free()

		for x in range(size.x):
			for y in range(size.y):
				var area = AREA_SCENE.instantiate()
				area.position = Vector2(x * Globals.AREA_SIZE, y * Globals.AREA_SIZE)
				areas.add_child(area)
				area.energy = initial_energy_per_area
