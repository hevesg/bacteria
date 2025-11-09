class_name HerbivoreBrain extends NeuralNetwork

func _init() -> void:
	super._init()
	for node in get_nodes():
		node.clear()
	for i in range(3):
		get_layer(0).get_node(i).connect_to(
			get_layer(1).get_node(i),
			1.0, 0.0
		)
