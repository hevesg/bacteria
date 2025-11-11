class_name NeuralNetworkDisplay extends Control

var neural_network: NeuralNetwork:
	set(nn):
		neural_network = nn
		queue_redraw()

var node_radius: float
var connection_width: float
var max_connections_to_draw: int = 500  # Performance limit

var _node_positions: Dictionary = {}  # node -> Vector2

func _ready() -> void:
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	if neural_network == null or neural_network.get_layers().is_empty():
		return
	
	var layers = neural_network.get_layers()
	if layers.is_empty():
		return
	
	node_radius = _get_node_size()
	connection_width = node_radius / 2.0
	# Calculate available space
	var available_width = size.x - (node_radius * 2)
	var available_height = size.y - (node_radius * 2)
	
	if available_width <= 0 or available_height <= 0:
		return
	
	# Calculate positions for all nodes
	_calculate_node_positions(layers, available_width, available_height)
	
	# Draw connections first (behind nodes)
	_draw_connections()
	
	# Draw nodes on top
	_draw_nodes()

func _get_node_size() -> float:
	var max_nodes_in_layer: int = 0
	for layer in neural_network.get_layers():
		var layer_size = layer.get_nodes().filter(func(node): return node.has_outbound_connections() or node.is_output()).size()
		if layer_size > max_nodes_in_layer:
			max_nodes_in_layer = layer_size
	var w: float = size.x / (neural_network.get_layers().size() * 2 - 1)
	var h: float = size.y / (max_nodes_in_layer * 2 - 1)
	return min(w, h) / 2.0

func _calculate_node_positions(layers: Array, available_width: float, available_height: float) -> void:
	_node_positions.clear()
	
	var layer_count = layers.size()
	
	# Calculate spacing between layers
	var layer_spacing = available_width / max(layer_count - 1, 1) if layer_count > 1 else 0
	
	# Position each layer
	for layer_index in range(layers.size()):
		var layer = layers[layer_index]
		var nodes = layer.get_nodes().filter(func(node): return node.has_outbound_connections() or node.is_output())
		
		if nodes.is_empty():
			continue
		
		# Calculate x position for this layer
		var layer_x = node_radius + (layer_index * layer_spacing)
		
		# Calculate spacing between nodes in this layer
		var node_count = nodes.size()
		var node_spacing = node_radius * 4.0
		var layer_offset = available_height / 2.0 - (nodes.size() * 2 - 2) * node_radius
		
		# Position each node vertically
		for node_index in range(node_count):
			var node = nodes[node_index]
			var node_y = node_radius + (node_index * node_spacing) + layer_offset
			_node_positions[node] = Vector2(layer_x, node_y)

func _draw_connections() -> void:
	if neural_network == null:
		return
	
	var connections_drawn = 0
	var nodes = neural_network.get_nodes()
	
	# Draw connections from each node's outbound connections
	for node in nodes:
		if connections_drawn >= max_connections_to_draw:
			break
		
		var from_pos = _node_positions.get(node)
		if from_pos == null:
			continue
		
		var outbound = node.get_outbound_connections()
		for target_node in outbound:
			if connections_drawn >= max_connections_to_draw:
				break
			
			var to_pos = _node_positions.get(target_node)
			if to_pos == null:
				continue
			
			var connection = node.get_outbound_connection_to(target_node)
			if connection == null:
				continue
			
			# Color based on weight
			var weight = connection._weight
			var weight_abs = abs(weight)
			var color = Color.WHITE
			
			if weight > 0:
				color = Color.WHITE.lerp(Color.WHITE, 1.0 - weight_abs)
			else:
				color = Color.BLACK.lerp(Color.WHITE, 1.0 - weight_abs)
						
			draw_line(from_pos, to_pos, color, connection_width)
			connections_drawn += 1

func _draw_nodes() -> void:
	if neural_network == null:
		return
	
	var layers = neural_network.get_layers()
	
	# Color nodes based on layer position
	for layer_index in range(layers.size()):
		var layer = layers[layer_index]
		var nodes = layer.get_nodes()
		
		# Determine layer color
		var layer_color = Color.WHITE
		
		# Draw each node
		for node in nodes:
			var pos = _node_positions.get(node)
			if pos == null:
				continue
			
			# Node color based on activation value (temp_value)
			var activation = abs(node._temp_value)
			var intensity = clamp(activation * 2.0, 0.3, 1.0)
			var node_color = layer_color.lerp(Color.BLACK, 1.0 - intensity)
			
			# Draw node circle
			draw_circle(pos, node_radius, Color.BLACK)
			
			# Draw border
			draw_circle(pos, node_radius, Color.WHITE, false, connection_width)
