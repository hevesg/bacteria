class_name Game extends Node2D

@onready var petriDish: PetriDish = $PetriDish
@onready var areas: Node2D = $PetriDish/Areas
@onready var herbivore_container: OrganismContainer = $PetriDish/HerbivoreContainer

@onready var algae_info_panel := $AlgaeInfoPanel
@onready var area_energy_info: DefinitionListItem = $AreaEnergy

@onready var total_energy_info: DefinitionListItem = $TotalEnergy

@onready var neural_network_display: NeuralNetworkDisplay = $NeuralNetworkDisplay
var neural_network: NeuralNetwork = NeuralNetwork.new(36, 3)

func _ready() -> void:
	for node in neural_network.get_nodes():
		node.clear()
	for i in range(3):
		neural_network.get_layer(0).get_node(i).connect_to(
			neural_network.get_layer(1).get_node(i),
			1.0, 0.0
		)
	neural_network_display.neural_network = neural_network
	
var loop: int = 0
func _on_timer_timeout() -> void:
	loop += 1	
	var area_total_energy = 0
	
	for area in areas.get_children():
		if area is DishArea:
			area_total_energy += area.energy
	
	area_energy_info.description_text = area_total_energy
	# neural_network.mutate()
	# neural_network_display.queue_redraw()


func _on_herbivore_drop(mouse_position: Vector2) -> void:
	var pos = mouse_position - petriDish.position
	herbivore_container.spawn(
		pos,
		randf() * PI * 2,
		Globals.MILLION,
		Globals.MILLION,
		2 * Globals.MILLION
	)
