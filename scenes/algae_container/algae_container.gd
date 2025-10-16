class_name AlgaeContainer extends Node2D

signal spawned_algae(algae_instance)

var algae_scene = load("res://scenes/algae/algae.tscn")

func spawn(position: Vector2, rotation: float, initial_energy: int):
	var new_algae = algae_scene.instantiate()
	new_algae.position = position
	new_algae.rotation = rotation
	new_algae.set_initial_energy(initial_energy)
	add_child(new_algae)
	spawned_algae.emit(new_algae)
	return new_algae
