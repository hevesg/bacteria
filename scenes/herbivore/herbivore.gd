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
