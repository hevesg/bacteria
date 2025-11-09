class_name SensoryOrganelle extends Organelle

@export
var raycast_count: int = 12

@export
var raycast_distance: float = 64.0

signal percepted

var raycasts: Array[RayCast2D]
	
func _build() -> void:
	raycasts = []
	for i in range(raycast_count):
		var raycast = RayCast2D.new()
		raycast.target_position = Vector2(raycast_distance, 0)
		raycast.rotation = (TAU / raycast_count) * i
		raycast.enabled = true
		add_child(raycast)
		raycasts.append(raycast)

func _destroy() -> void:
	for raycast in raycasts:
		raycast.queue_free()
		
func percept() -> void:
	_build()
	
	var input_nodes: Array[float] = []
	input_nodes.resize(raycast_count * 5)
	input_nodes.fill(0.0)
	
	for i in range(raycasts.size()):
		var raycast = raycasts[i]
		
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			var collision_point = raycast.get_collision_point()
			
			var distance_to_collision = global_position.distance_to(collision_point)
			var distance_ratio = 1.0 - (distance_to_collision / raycast_distance)
			distance_ratio = clamp(distance_ratio, 0.0, 1.0)
						
			if collider is StaticBody2D:
				input_nodes[i] = distance_ratio
			elif collider is Algae:
				if collider.is_alive:
					input_nodes[i + raycast_count] = distance_ratio
				else:
					input_nodes[i + raycast_count * 2] = distance_ratio
			elif collider is Herbivore:
				if collider.is_alive:
					input_nodes[i + raycast_count * 3] = distance_ratio
				else:
					input_nodes[i + raycast_count * 4] = distance_ratio
	_destroy()
	percepted.emit(input_nodes)
