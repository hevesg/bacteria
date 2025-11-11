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

func get_output_nodes() -> Array[NetworkNode]:
	return get_nodes().filter(func(item: NetworkNode): return item.is_output() )

func get_input_nodes() -> Array[NetworkNode]:
	return get_nodes().filter(func(item: NetworkNode): return item.is_input() )

func get_hidden_nodes() -> Array[NetworkNode]:
	return get_nodes().filter(func(item: NetworkNode): return item.is_hidden() )

func forward(inputs: Array[float]) -> Array[float]:
	for node in _nodes:
		node._temp_value = 0.0
	
	var input_nodes = get_input_nodes()
	if inputs.size() != input_nodes.size():
		push_error("Input size mismatch: expected %d, got %d" % [input_nodes.size(), inputs.size()])
		return []
	
	for i in range(input_nodes.size()):
		input_nodes[i]._temp_value = inputs[i]

	var layers = get_layers()
	for layer_index in range(1, layers.size()):
		var layer = layers[layer_index]
		var nodes = layer.get_nodes()
		
		for node in nodes:
			var sum: float = 0.0
			var inbound = node.get_inbound_connections()
			
			for source_node in inbound:
				var connection = node.get_inbound_connection_from(source_node)
				if connection != null:
					sum += source_node._temp_value * connection._weight
					sum += connection._bias
			
			node._temp_value = Globals.sigmoid(sum)
	
	var output_nodes = get_output_nodes()
	var outputs: Array[float] = []
	for node in output_nodes:
		outputs.append(node._temp_value)
	
	return outputs

# Clone the neural network with all its structure, weights, and biases
func clone() -> NeuralNetwork:
	# Calculate layer structure from existing network
	var input_count = get_input_nodes().size()
	var output_count = get_output_nodes().size()
	var hidden_layers: Array[int] = []
	
	var layers = get_layers()
	for i in range(1, layers.size() - 1):  # Skip input and output layers
		hidden_layers.append(layers[i].get_nodes().size())
	
	# Create new network with same structure
	var cloned = NeuralNetwork.new(input_count, output_count, hidden_layers)
	
	# Create mapping from old nodes to new nodes
	var node_map: Dictionary = {}  # old_node -> new_node
	
	var old_layers = get_layers()
	var new_layers = cloned.get_layers()
	
	# Map nodes by layer position
	for layer_index in range(old_layers.size()):
		var old_layer = old_layers[layer_index]
		var new_layer = new_layers[layer_index]
		var old_nodes = old_layer.get_nodes()
		var new_nodes = new_layer.get_nodes()
		
		# Map nodes at same positions
		for node_index in range(old_nodes.size()):
			if node_index < new_nodes.size():
				node_map[old_nodes[node_index]] = new_nodes[node_index]
	
	# Copy all connections with their weights and biases
	for old_node in _nodes:
		var new_node = node_map.get(old_node)
		if new_node == null:
			continue
		
		var old_outbound = old_node.get_outbound_connections()
		for old_target in old_outbound:
			var new_target = node_map.get(old_target)
			if new_target == null:
				continue
			
			var old_connection = old_node.get_outbound_connection_to(old_target)
			if old_connection != null:
				# Create connection with same weight and bias
				new_node.connect_to(new_target, old_connection._weight, old_connection._bias)
	
	return cloned

func insert_layer_at(index: int) -> NetworkLayer:
	if index > 0 and index < _layers.size():
		var layer = NetworkLayer.new(self)
		_layers.insert(index, layer)
		return layer
	else:
		return null
	
func _init(input_count: int = 1, output_count: int = 1, hidden_layers: Array[int] = []) -> void:
	var layers_count: Array[int] = []
	layers_count.append(input_count)
	layers_count.append_array(hidden_layers)
	layers_count.append(output_count)
	
	for layer_count in layers_count:
		var layer = NetworkLayer.new(self)
		for node_count in layer_count:
			layer.insert_node()
		_layers.append(layer)
		
	for node in _nodes:
		var next_layer = node._layer.next()
		if next_layer:
			for other_node in next_layer._nodes:
				node.connect_to(other_node)

func split_connection(from: NetworkNode, to: NetworkNode) -> void:
	if from._outbound_connections.has(to):
		var connection = from._outbound_connections.get(to)
		var layer
		var layer_index: int = (to.get_layer().get_index() + from.get_layer().get_index()) / 2
		if from.get_layer().get_index() == layer_index:
			layer = insert_layer_at(layer_index + 1)
		else:
			layer = get_layer(layer_index)
		var new_node = layer.insert_node()
		new_node.connect_to(to, connection._weight, connection._bias)
		from.connect_to(new_node)
		from.disconnect_from(to)

func mutate() -> void:
	var from_node: NetworkNode = get_nodes().filter(func(item): return not item.is_output()).pick_random()
	var to_node: NetworkNode = from_node.get_higher_nodes(2).pick_random()
	if from_node.get_outbound_connections().has(to_node):
		split_connection(from_node, to_node)
	else:
		from_node.connect_to(to_node)
		var longest_connection = to_node.get_longest_inbound_connection()
		if longest_connection.get_length() > 2 and to_node.get_inbound_connections().size() > 1 and longest_connection._from.get_outbound_connections().size() > 1:
			longest_connection._from.disconnect_from(to_node)

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
	
	func insert_node() -> NetworkNode:
		var node = NetworkNode.new(self)
		_nodes.append(node)
		_network._nodes.append(node)
		return node

	func remove(node: NetworkNode) -> void:
		_nodes.erase(node)

	func remove_at(index: int) -> void:
		if index < _nodes.size() and index >= 0:
			_nodes.remove_at(index)

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
		if other.get_layer().get_index() > get_layer().get_index():
			var connection: NetworkConnection = NetworkConnection.new(self, other, weight, bias)
			_outbound_connections.set(other, connection)
			other._inbound_connections.set(self, connection)
		else:
			push_error("Cannot connect to lower layer nodes")
	
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
	
	func has_outbound_connections() -> bool:
		return !get_outbound_connections().is_empty()
	
	func get_inbound_connections() -> Dictionary[NetworkNode, NetworkConnection]:
		return _inbound_connections.duplicate()
	
	func has_inbound_connections() -> bool:
		return !get_inbound_connections().is_empty()
	
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
	
	func get_higher_nodes(target: int = 2) -> Array[NetworkNode]:
		var nodes: Array[NetworkNode] = []
		var layer = get_layer().next().next()
		if layer:
			return layer.get_nodes()
		else:
			return get_layer().next().get_nodes()
		#while layer:
		#	nodes.append_array(layer.get_nodes())
		#	layer = layer.next()
		#return nodes
	
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
	
	func get_longest_inbound_connection() -> NetworkConnection:
		if _inbound_connections.is_empty():
			return
		
		var connection: NetworkConnection
		var length: int = 0
		for con in _inbound_connections.values():
			var len = con.get_length()
			if len > length:
				connection = con
				length = len
		return connection
	
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
	
	func get_length() -> int:
		return _to.get_layer().get_index() - _from.get_layer().get_index()
