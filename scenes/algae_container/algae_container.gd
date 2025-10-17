class_name AlgaeContainer extends Node2D

signal spawned_algae(algae_instance)

var algae_scene = load("res://scenes/algae/algae.tscn")

func spawn(pos: Vector2, rot: float, initial_energy: int):
	var new_algae = algae_scene.instantiate()
	new_algae.position = pos
	new_algae.rotation = rot
	new_algae.set_initial_energy(initial_energy)
	add_child(new_algae)
	spawned_algae.emit(new_algae)
	return new_algae

func empty():
	for child in get_children():
		child.queue_free()
