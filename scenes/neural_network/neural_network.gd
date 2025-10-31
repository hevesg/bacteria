class_name NeuralNetwork extends Resource

var _layers: Array[NetworkLayer] = []
var _nodes: Array[NetworkNode] = []

class NetworkLayer:
	var _network: NeuralNetwork
	var _index: int
	var _nodes: Array[NetworkNode] = []

	func _init(network: NeuralNetwork) -> void:
		_network = network
		_index = network._layers.size()
		
	func add(node: NetworkNode) -> void:
		_nodes.append(node)
		
	func next() -> NetworkLayer:
		if (_index < _network._layers.size() - 1):
			return _network._layers[_index + 1]
		else:
			return null
		
	func previous() -> NetworkLayer:
		if (_index > 0):
			return _network._layers[_index - 1]
		else:
			return null
		
	func has_next() -> bool:
		return !!next()
		
	func has_previous() -> bool:
		return !!previous()

class NetworkNode:
	var _layer: NetworkLayer
	var _connections: Dictionary[NetworkNode, NetworkConnection] = {}
	
	func _init(layer: NetworkLayer) -> void:
		_layer = layer
	
	func connectTo(other: NetworkNode, weight = null, bias = null) -> void:
		_connections.set(other, NetworkConnection.new(self, other, weight, bias))
	
	func clear() -> void:
		_connections.clear()
	
class NetworkConnection:
	var _from: NetworkNode
	var _to: NetworkNode
	var _weight: float
	var _bias: float

	func _init(from: NetworkNode, to: NetworkNode, weight = null, bias = null) -> void:
		_from = from
		_to = to
		_weight = weight if weight is float else randf_range(-1.0, 1.0)
		_bias = bias if bias is float else randf_range(-1.0, 1.0)

func _init(input_count: int = 1, output_count: int = 1, hidden_layers: Array[int] = []) -> void:
	var layers_count: Array[int] = []
	layers_count.append(input_count)
	layers_count.append_array(hidden_layers)
	layers_count.append(output_count)
	
	for layer_count in layers_count:
		var layer = NetworkLayer.new(self)
		for node_count in layer_count:
			var node = NetworkNode.new(layer)
			_nodes.append(node)
			layer._nodes.append(node)
		_layers.append(layer)
		
	for node in _nodes:
		var next_layer = node._layer.next()
		if next_layer:
			for other_node in next_layer._nodes:
				node.connectTo(other_node)
