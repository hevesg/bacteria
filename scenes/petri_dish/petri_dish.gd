@tool
class_name PetriDish extends Node2D

@onready var _northern_wall: StaticBody2D = $NorthernWall
@onready var _eastern_wall: StaticBody2D = $EasternWall
@onready var _southern_wall: StaticBody2D = $SouthernWall
@onready var _western_wall: StaticBody2D = $WesternWall

@onready var areas: Node2D = $Areas
@onready var algae_container = $AlgaeContainer

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

@export_range(
	Globals.HUNDRED_THOUSAND,
	Globals.MILLION,
	Globals.HUNDRED_THOUSAND
)
var initial_energy_per_area: int = Globals.HUNDRED_THOUSAND:
	set(value):
		initial_energy_per_area = clampi(value, Globals.HUNDRED_THOUSAND, Globals.MILLION)
		if areas:
			for child in areas.get_children():
				child.energy = initial_energy_per_area

@export
var initial_algae: int = 0:
	set(value):
		initial_algae = clampi(value, 0, size.x * size.y)
		_update_algae()
	
func _ready() -> void:
	size = size
	initial_algae = initial_algae

func _update_walls() -> void:
	_update_wall(_northern_wall, size.x, false, -1)
	_update_wall(_southern_wall, size.x, false, 1)
	_update_wall(_eastern_wall, size.y, true, 1)
	_update_wall(_western_wall, size.y, true, -1)
	
func _update_wall(
	wall: StaticBody2D,
	scale_value: int,
	move_on_horizontal_axis: bool,
	position_value: int
) -> void:
	if wall:
		wall.scale.x = scale_value + 1
		if move_on_horizontal_axis:
			wall.position.x = size.x * position_value * Globals.HALF_AREA_SIZE
		else:
			wall.position.y = size.y * position_value * Globals.HALF_AREA_SIZE

func _update_areas() -> void:
	if areas:
		var areas_offset = Vector2i(
			-(size.x - 1) * int(Globals.HALF_AREA_SIZE),
			-(size.y - 1) * int(Globals.HALF_AREA_SIZE)
		)

		for child in areas.get_children():
			child.queue_free()

		for x in range(size.x):
			for y in range(size.y):
				var area = AREA_SCENE.instantiate()
				area.position = Vector2(
					x * Globals.AREA_SIZE + areas_offset.x,
					y * Globals.AREA_SIZE + areas_offset.y
				)
				areas.add_child(area)
				area.energy = initial_energy_per_area

func _update_algae():
	if algae_container:
		algae_container.empty()

		var areas_children = areas.get_children().duplicate()

		var selected_areas = []
		for i in range(initial_algae):
			if areas_children.size() > 0:
				var random_index = randi() % areas_children.size()
				var selected_area = areas_children[random_index]
				selected_areas.append(selected_area)
				areas_children.remove_at(random_index)
	
		for area in selected_areas:
			algae_container.spawn(
				area.position,
				randf() * 2 * PI,
				Globals.HUNDRED_THOUSAND,
				Globals.HUNDRED_THOUSAND
			)
