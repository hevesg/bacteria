class_name OrganismContainer extends Node2D

signal on_new_organism(organism_instance)

signal on_empty()

@onready
var _on_frame_timer: Timer = $OnFrameTimer

@onready
var _container: Node2D = $Container

@export
var organism_scene: PackedScene

@export_range(1, 12, 1)
var batch_number: int = 6

@export_range(0.1, 2.0, 0.1)
var on_frame_cycle: float = 1.0

var _iterator_index: int = -1

func _ready() -> void:
	_on_frame_timer.wait_time = 1.0 / batch_number

func spawn(
	pos: Vector2,
	rot: float,
	initial_energy: int,
	initial_cumulative_energy: int,
	energy_when_split: int
) -> Organism:
	if organism_scene == null:
		push_error("OrganismContainer: organism_scene is not set!")
		return null
	
	var new_organism = organism_scene.instantiate()
	new_organism.position = pos
	new_organism.rotation = rot
	_container.add_child(new_organism)
	new_organism.init_organism(
		initial_energy,
		initial_cumulative_energy,
		energy_when_split
	)
	on_new_organism.emit(new_organism)
	return new_organism

func empty() -> void:
	for child in _container.get_children():
		if child is Organism:
			child.queue_free()
	on_empty.emit()


func _on_frame_timeout() -> void:
	_iterator_index = (_iterator_index + 1) % batch_number
	for i in range(_iterator_index, _container.get_children().size(), batch_number):
		var child = _container.get_children()[i]
		if child is Organism:
			child.on_frame(1.0)
