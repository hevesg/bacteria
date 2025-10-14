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
			_setMass(float(energy) / Globals.ENERGY_PER_SIZE)
		else:
			if energy <=  value:
				_cumulative_energy += value - energy
		
			energy = value

			if float(energy) / Globals.ENERGY_PER_SIZE >= mass:
				_setMass(float(energy) / Globals.ENERGY_PER_SIZE)

var current_area: DishArea = null:
	set(value):
		if current_area:
			var force: int = int(linear_velocity.length() * mass)
			current_area.transfer_energy_to(
				force * Globals.ENERGY_TRANSFER_AMOUNT,
				value
			)
		current_area = value
func half() -> void:
	energy = energy / 2
	_setMass(float(energy) / Globals.ENERGY_PER_SIZE)

func _ready() -> void:
	energy = energy
	gravity_scale = 0
	linear_damp = 1

func _update_scale(node: Node2D,new_scale: float) -> void:
	if node:
		node.scale = Vector2.ONE * new_scale

func _setMass(amount: float) -> void:
	mass = amount
	var new_scale = pow(mass, 1.0 / 3.0)
	_update_scale(sprite, new_scale)
	_update_scale(collision, new_scale)
