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
	var _outbound: Dictionary[NetworkNode, NetworkConnection] = {}
	var _inbound: Dictionary[NetworkNode, NetworkConnection] = {}
	var _temp_value: float = 0.0
	
	func _init(layer: NetworkLayer) -> void:
		_layer = layer
	
	func connectTo(other: NetworkNode, weight = null, bias = null) -> void:
		var connection: NetworkConnection = NetworkConnection.new(self, other, weight, bias)
		_outbound.set(other, connection)
		other._inbound.set(self, connection)
		
	
	func disconnectFrom(other: NetworkNode) -> void:
		if _outbound.has(other):
			_outbound.erase(other)
		if other._inbound.has(self):
			other._inbound.erase(self)
	
	func clear() -> void:
		# Collect keys first to avoid modifying dictionary during iteration
		var keys = _outbound.keys()
		for other in keys:
			disconnectFrom(other)
	
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
		
	func mutate(weight_limit: float = 0.1, bias_limit = 1.0) -> void:
		_weight = Globals.sigmoid(_weight * (1 + randf_range(-weight_limit, weight_limit)))
		_bias = _bias + randf_range(-bias_limit, bias_limit)

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

func get_non_output_nodes() -> Array[NetworkNode]:
	var array: Array[NetworkNode] = []
	for layer_index in range(_layers.size() - 1):
		array.append_array(_layers[layer_index]._nodes)
	return array

func get_nodes_with_outbound_connections(size: int = 1) -> Array[NetworkNode]:
	var array: Array[NetworkNode] = []
	var nodes = get_non_output_nodes()
	for node in nodes:
		if node._outbound.size() >= size:
			array.append(node)
	return array

func mutate_random_connection() -> void:
	var nodes: Array[NetworkNode] = get_nodes_with_outbound_connections()
	if nodes.size() > 0:
		nodes.pick_random()._outbound.pick_random().mutate() 

func remove_random_connection() -> void:
	var nodes: Array[NetworkNode] = get_nodes_with_outbound_connections(2)
	if nodes.size() > 0:
		nodes.pick_random()._outbound.remove()
