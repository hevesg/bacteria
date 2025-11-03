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

func get_non_output_nodes() -> Array[NetworkNode]:
	return _nodes.duplicate().filter(func(item: NetworkNode): return item.get_layer )

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

	func is_output() -> bool:
		return _network.get_layers().find(self) == _network.get_layers().size() - 1

	func is_input() -> bool:
		return _network.get_layers().find(self) == 0

	func is_hidden() -> bool:
		return not is_input() and not is_output()

	func _init(network: NeuralNetwork) -> void:
		_network = network
	
	func get_index() -> int:
		return _network.get_layers().find(self)
	
	func add(node: NetworkNode) -> void:
		_nodes.append(node)
	
	func next() -> NetworkLayer:
		var index = get_index()
		if (index < _network._layers.size() - 1):
			return _network._layers[index + 1]
		else:
			return null

	func previous() -> NetworkLayer:
		var index = get_index()
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
	
	func get_layer() -> NetworkLayer:
		return _layer 

	func connect_to(other: NetworkNode, weight = null, bias = null) -> void:
		var connection: NetworkConnection = NetworkConnection.new(self, other, weight, bias)
		_outbound_connections.set(other, connection)
		other._inbound_connections.set(self, connection)
		
	
	func disconnect_from(other: NetworkNode) -> void:
		if _outbound_connections.has(other):
			_outbound_connections.erase(other)
		if other._inbound_connections.has(self):
			other._inbound_connections.erase(self)
	
	func clear() -> void:
		# Collect keys first to avoid modifying dictionary during iteration
		var keys = _outbound_connections.keys()
		for other in keys:
			disconnect_from(other)
	
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
	
	func get_higher_nodes() -> Array[NetworkNode]:
		var nodes: Array[NetworkNode] = []
		var layer = get_layer().next()
		while layer:
			nodes.append_array(layer.get_nodes())
			layer = layer.next()
		return nodes
	
	func get_lower_nodes() -> Array[NetworkNode]:
		var nodes: Array[NetworkNode] = []
		var layer = get_layer().previous()
		while layer:
			nodes.append_array(layer.get_nodes())
			layer = layer.previous()
		return nodes
	
	func is_output() -> bool:
		return _layer.is_output()
	
	func is_input() -> bool:
		return _layer.is_input()
	
	func is_hidden() -> bool:
		return _layer.is_hidden()
	
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
				node.connect_to(other_node)

func insert_layer_at(index: int) -> NetworkLayer:
	if index > 0 and index < _layers.size():
		var layer = NetworkLayer.new(self)
		_layers.insert(index, layer)
		return layer
	else:
		return null
