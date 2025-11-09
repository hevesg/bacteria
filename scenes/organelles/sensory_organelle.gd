class_name SensoryOrganelle extends Organelle

@export
var raycast_count: int = 12

@export
var raycast_distance: float = 64.0

var _collider_types := [StaticBody2D, Algae, Herbivore]
signal percepted

var raycasts: Array[RayCast2D] = []

func _ready() -> void:
	for i in range(raycast_count):
		var raycast = RayCast2D.new()
		raycast.target_position = Vector2(raycast_distance, 0)
		raycast.rotation = (TAU / raycast_count) * i
		raycast.enabled = false
		add_child(raycast)
		raycasts.append(raycast)
		
func percept() -> void:
	var data: Array[float] = []
	data.resize(raycast_count * _collider_types.size())
	data.fill(0.0)
	
	for i in range(raycasts.size()):
		var raycast = raycasts[i]
		raycast.enabled = true
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			var collision_point = raycast.get_collision_point()
			
			var distance_to_collision = global_position.distance_to(collision_point)
			var distance_ratio = 1.0 - (distance_to_collision / raycast_distance)
			distance_ratio = clamp(distance_ratio, 0.0, 1.0)
		
			for j in range(_collider_types.size()):
				if is_instance_of(collider, _collider_types[j]):
					data[i + j * raycast_count] = distance_ratio
					break
	percepted.emit(data)
