class_name Particle extends RigidBody2D

@onready
var collision: CollisionShape2D = $Collision

@onready
var sprite: Sprite2D = $Sprite

var _cumulative_energy: int = 0

@export_range(
	Globals.HUNDRED_THOUSAND,
	Globals.MILLION,
	Globals.HUNDRED_THOUSAND
)
var energy: int = 0:
	set(value):
		value = clampi(value, 0, value)

		if Engine.is_editor_hint():
			energy = value
			_setMass(float(energy) / Globals.ENERGY_PER_SIZE)
		else:
			if value > energy:
				_cumulative_energy += value - energy
			energy = value

			if float(energy) / Globals.ENERGY_PER_SIZE >= mass:
				_setMass(float(energy) / Globals.ENERGY_PER_SIZE)

var current_area: DishArea = null:
	set(value):
		if current_area:
			current_area.transfer_energy_to(
				int(getForce() * Globals.ENERGY_TRANSFER_AMOUNT),
				value
			)
		current_area = value

func getForce() -> float:
	return linear_velocity.length() * mass

func set_initial_energy(amount: int, cumulative: int = 0):
	energy = amount
	_cumulative_energy = cumulative

func half() -> Array[int]:
	var amount: int = int(energy / 2.0)
	var cumulative: int = int(_cumulative_energy / 2.0)
	
	energy -= amount
	_cumulative_energy -= cumulative
	_setMass(float(energy) / Globals.ENERGY_PER_SIZE)
	return [amount, cumulative]

func _ready() -> void:
	energy = energy
	gravity_scale = 0
	linear_damp = 1

func _update_scale(node: Node2D, new_scale: float) -> void:
	if node:
		node.scale = Vector2.ONE * new_scale

func _setMass(amount: float) -> void:
	mass = amount
	var new_scale = pow(mass, 1.0 / 3.0)
	_update_scale(sprite, new_scale)
	_update_scale(collision, new_scale)
