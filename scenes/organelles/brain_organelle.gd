@tool
class_name BrainOrganelle extends Organelle

@export var input_nodes: int = 3

@onready var brain: NeuralNetworkDisplay = $Brain
var neural_network: NeuralNetwork

func _ready() -> void:
	neural_network = NeuralNetwork.new(input_nodes, 3)
	brain.neural_network = neural_network
	brain.queue_redraw()
