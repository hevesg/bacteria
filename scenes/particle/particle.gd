@tool
class_name Particle extends RigidBody2D

@onready
var collision: CollisionShape2D = $Collision

@onready
var sprite: Sprite2D = $Sprite

var _cumulative_energy: int = 0

@export_range(
	Globals.ENERGY_PER_SIZE,
	Globals.ENERGY_PER_SIZE * 10e2,
	Globals.ENERGY_PER_SIZE
)
var energy: int = 0:
	set(value):
		value = clampi(value, 0, value)

		if Engine.is_editor_hint():
			energy = value
			mass = float(energy) / Globals.ENERGY_PER_SIZE
			var new_scale = pow(mass, 1.0 / 3.0)
			_update_scale(sprite, new_scale)
			_update_scale(collision, new_scale)
		else:
			if energy <=  value:
				_cumulative_energy += value - energy
		
			energy = value

			if energy / Globals.ENERGY_PER_SIZE >= mass:
				mass = float(energy) / Globals.ENERGY_PER_SIZE
				var new_scale = pow(mass, 1.0 / 3.0)
				_update_scale(sprite, new_scale)
				_update_scale(collision, new_scale)

var current_area: DishArea = null:
	set(value):
		if current_area:
			var force: float = int(linear_velocity.length() * mass)
			current_area.transfer_energy_to(
				force * Globals.ENERGY_TRANSFER_AMOUNT,
				value
			)
		current_area = value

func _ready() -> void:
	energy = energy
	print(name, " is created with energy: ", energy, " Size: ", mass)

func _update_scale(node: Node2D,new_scale: float) -> void:
	if node:
		node.scale = Vector2.ONE * new_scale
