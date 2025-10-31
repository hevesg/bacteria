class_name SensoryOrgan extends Node2D

@export
var raycast_count: int = 12

@export
var raycast_distance: float = 64.0

var raycasts: Array[RayCast2D] = []
var raycast_lines: Array[Line2D] = []

func _ready() -> void:
	for i in range(raycast_count):
		var raycast = RayCast2D.new()
		raycast.target_position = Vector2(raycast_distance, 0)
		raycast.rotation = (TAU / raycast_count) * i
		raycast.enabled = true
		add_child(raycast)
		raycasts.append(raycast)
		
		var line = Line2D.new()
		line.width = 2.0
		line.default_color = Color.BLACK
		line.add_point(Vector2.ZERO)
		line.add_point(Vector2(raycast_distance, 0))
		raycast.add_child(line)
		raycast_lines.append(line)

func percept() -> Array[float]:
	var input_nodes: Array[float] = []
	input_nodes.resize(raycast_count * 5)
	input_nodes.fill(0.0)
	
	for i in range(raycasts.size()):
		var raycast = raycasts[i]
		var line = raycast_lines[i]
		
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			var collision_point = raycast.get_collision_point()
			
			var distance_to_collision = global_position.distance_to(collision_point)
			var distance_ratio = 1.0 - (distance_to_collision / raycast_distance)
			distance_ratio = clamp(distance_ratio, 0.0, 1.0)
			
			line.set_point_position(1, raycast.to_local(collision_point))
			
			if collider is StaticBody2D:
				line.default_color = Color.BLACK
				input_nodes[i] = distance_ratio
			elif collider is Algae:
				if collider.is_alive:
					line.default_color = Color.GREEN
					input_nodes[i + raycast_count] = distance_ratio
				else:
					line.default_color = Color.DARK_GREEN
					input_nodes[i + raycast_count * 2] = distance_ratio
			elif collider is Herbivore:
				if collider.is_alive:
					line.default_color = Color.BLUE
					input_nodes[i + raycast_count * 3] = distance_ratio
				else:
					line.default_color = Color.DARK_BLUE
					input_nodes[i + raycast_count * 4] = distance_ratio

		else:
			line.set_point_position(1, Vector2(raycast_distance, 0))
			line.default_color = Color.WHITE
	return input_nodes
