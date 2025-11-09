class_name Game extends Node2D

@onready var petriDish: PetriDish = $PetriDish
@onready var areas: Node2D = $PetriDish/Areas
@onready var herbivore_container: OrganismContainer = $PetriDish/HerbivoreContainer

@onready var algae_info_panel := $AlgaeInfoPanel
@onready var area_energy_info: DefinitionListItem = $AreaEnergy

@onready var total_energy_info: DefinitionListItem = $TotalEnergy

@onready var neural_network_display: NeuralNetworkDisplay = $NeuralNetworkDisplay
var neural_network: NeuralNetwork = NeuralNetwork.new(8,3)

func _ready() -> void:
	for node in neural_network.get_nodes():
		node.clear()
	for i in range(3):
		neural_network.get_layer(0).get_node(i).connect_to(
			neural_network.get_layer(1).get_node(i),
			1.0, 0.0
		)
	neural_network_display.set_neural_network(neural_network)

func pick_random_non_output_neural_network_node():
	return neural_network.get_nodes().filter(func(item): return not item.is_output()).pick_random()

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
			layer = neural_network.insert_layer_at(layer_index + 1)
		else:
			layer = neural_network.get_layer(layer_index)
		var new_node = layer.insert_node()
		new_node.connect_to(to_node)
		from_node.connect_to(new_node)
		from_node.disconnect_from(to_node)
		
var i: int = 0

func _on_timer_timeout() -> void:	
	var area_total_energy = 0
	
	for area in areas.get_children():
		if area is DishArea:
			area_total_energy += area.energy
	i = i + 1
	#add_connection()
	#if i % 5 == 0:
		#split_connection()
	
	area_energy_info.description_text = area_total_energy
	
	neural_network_display.queue_redraw()

func _on_herbivore_drop(mouse_position: Vector2) -> void:
	var pos = mouse_position - petriDish.position
	herbivore_container.spawn(
		pos,
		randf() * PI * 2,
		Globals.MILLION,
		Globals.MILLION,
		2 * Globals.MILLION
	)
