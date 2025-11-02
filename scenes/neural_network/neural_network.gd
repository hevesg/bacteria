class_name NeuralNetwork extends Resource

var _layers: Array[NetworkLayer] = []
var _nodes: Array[NetworkNode] = []

func get_layers() -> Array[NetworkLayer]:
	return _layers.duplicate()

func get_layer(index: int) -> NetworkLayer:
	if index < _layers.size() and index >= 0:
		return  _layers[index]
	else:
		return null
	
func get_nodes() -> Array[NetworkNode]:
	return _nodes.duplicate()

class NetworkLayer:
	var _network: NeuralNetwork
	var _nodes: Array[NetworkNode] = []

	func get_nodes() -> Array[NetworkNode]:
		return _nodes.duplicate()

	func get_node(index: int) -> NetworkNode:
		if index < _nodes.size() and index >= 0:
			return _nodes[index]
		else:
			return null

	func _init(network: NeuralNetwork) -> void:
		_network = network
		
	func add(node: NetworkNode) -> void:
		_nodes.append(node)
		
	func next() -> NetworkLayer:
		var index = _network.get_layers().find(self)
		if (index < _network._layers.size() - 1):
			return _network._layers[index + 1]
		else:
			return null
		
	func previous() -> NetworkLayer:
		var index = _network.get_layers().find(self)
		if (index > 0):
			return _network._layers[index - 1]
		else:
			return null
		
	func has_next() -> bool:
		return !!next()
		
	func has_previous() -> bool:
		return !!previous()

class NetworkNode:
	var _layer: NetworkLayer
	var _outbound_connections: Dictionary[NetworkNode, NetworkConnection] = {}
	var _inbound_connections: Dictionary[NetworkNode, NetworkConnection] = {}
	var _temp_value: float = 0.0
	
	func _init(layer: NetworkLayer) -> void:
		_layer = layer
	
	func connectTo(other: NetworkNode, weight = null, bias = null) -> void:
		var connection: NetworkConnection = NetworkConnection.new(self, other, weight, bias)
		_outbound_connections.set(other, connection)
		other._inbound_connections.set(self, connection)
		
	
	func disconnectFrom(other: NetworkNode) -> void:
		if _outbound_connections.has(other):
			_outbound_connections.erase(other)
		if other._inbound_connections.has(self):
			other._inbound_connections.erase(self)
	
	func clear() -> void:
		# Collect keys first to avoid modifying dictionary during iteration
		var keys = _outbound_connections.keys()
		for other in keys:
			disconnectFrom(other)
	
	func get_outbound_connections() -> Dictionary[NetworkNode, NetworkConnection]:
		return _outbound_connections.duplicate()
	
	func get_inbound_connections() -> Dictionary[NetworkNode, NetworkConnection]:
		return _inbound_connections.duplicate()
		
	func get_outbound_connection_to(node: NetworkNode) -> NetworkConnection:
		if _outbound_connections.has(node):
			return _outbound_connections.get(node)
		else:
			return null
		
	func get_inbound_connection_from(node: NetworkNode) -> NetworkConnection:
		if _inbound_connections.has(node):
			return _inbound_connections.get(node)
		else:
			return null

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

func insert_layer_at(index: int) -> void:
	if index > 0 and index < _layers.size():
		_layers.insert(index, NetworkLayer.new(self))
