class_name Herbivore extends Organism

@onready
var sensory_organelle: SensoryOrganelle = $SensoryOrganelle

@onready
var timer: Timer = $Timer

var brain: NeuralNetwork

func _ready() -> void:
	super._ready()
	var so = 0
	for node in get_children():
		if node is Organelle:
			node.position.y = so
			so += 10
	
	brain = NeuralNetwork.new(3 + 3 * 12, 3)
	for node in brain.get_nodes():
		node.clear()
	for i in range(3):
		brain.get_layer(0).get_node(i).connect_to(
			brain.get_layer(1).get_node(i),
			2.0, -1.0
		)

func _on_timer_timeout() -> void:
	if is_alive:
		sensory_organelle.percept()

func _on_body_entered(body: Node) -> void:
	if body is Algae and body.is_dead and is_alive:
		set_energy(energy.current + body.energy.cumulative)
		body.queue_free()

func pick_random_non_output_neural_network_node():
	return brain.get_nodes().filter(func(item): return not item.is_output()).pick_random()

func add_connection() -> void:
	var from_node = pick_random_non_output_neural_network_node()
	var to_node = from_node.get_higher_nodes().pick_random()
	from_node.connect_to(to_node)

func split_connection() -> void:
	var from_node = pick_random_non_output_neural_network_node()
	if from_node.get_outbound_connections().size() > 0:
		var to_node = from_node.get_outbound_connections().keys().pick_random()
		var layer_index = (from_node.get_layer().get_index() + to_node.get_layer().get_index()) / 2
		var layer
		if from_node.get_layer().get_index() == layer_index:
			layer = brain.insert_layer_at(layer_index + 1)
		else:
			layer = brain.get_layer(layer_index)
		var new_node = layer.insert_node()
		new_node.connect_to(to_node)
		from_node.connect_to(new_node)
		from_node.disconnect_from(to_node)

func _on_sensory_organelle_percepted(perceptions: Array[float]) -> void:
	var inputs: Array[float] = [
			randf_range(0.0, 1.0),
			randf_range(0.0, 1.0),
			randf_range(0.0, 1.0),
		]
	inputs.append_array(perceptions)
	var outputs = brain.forward(inputs)
	timer.wait_time = 1.0 + outputs[2]
	jet(outputs[0] * 3000.0, outputs[1] * 10000.0 - 5000, true)
