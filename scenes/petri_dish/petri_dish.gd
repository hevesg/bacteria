@tool
class_name PetriDish extends Node2D

@onready var northernWall: StaticBody2D = $NorthernWall
@onready var easternWall: StaticBody2D = $EasternWall
@onready var southernWall: StaticBody2D = $SouthernWall
@onready var westernWall: StaticBody2D = $WesternWall

const AREA_SIZE: int = 64

@export var size: Vector2i = Vector2i(10, 10):
	set(value):
		size = Vector2i(
			clampi(value.x, 1, 20),
			clampi(value.y, 1, 20)
		)
		
		_update_walls()

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
			wall.position.x = size.x * position_value * AREA_SIZE / 2.0
		else:
			wall.position.y = size.y * position_value * AREA_SIZE / 2.0
