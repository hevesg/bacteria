class_name OrganismContainer extends Node2D

signal on_new_organism(organism_instance)

signal on_empty()

@export
var organism_scene: PackedScene

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
	new_organism.init_organism(
		initial_energy,
		initial_cumulative_energy,
		energy_when_split
	)
	add_child(new_organism)
	on_new_organism.emit(new_organism)
	return new_organism

func empty() -> void:
	for child in get_children():
		child.queue_free()
	on_empty.emit()
