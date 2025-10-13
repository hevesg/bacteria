@tool
class_name Particle extends RigidBody2D

@onready var collision: CollisionShape2D = $Collision
@onready var sprite: Sprite2D = $Sprite

var _cumulative_energy: int = 0
var _energy: int = 0

var current_area: DishArea = null:
	set(value):
		if current_area:
			var force: float = int(linear_velocity.length() * mass)
			current_area.transfer_energy_to(
				force * Globals.ENERGY_TRANSFER_AMOUNT,
				value
				)
			
		current_area = value

@export_range(
	Globals.ENERGY_PER_SIZE,
	Globals.ENERGY_PER_SIZE * 1000,
	Globals.ENERGY_PER_SIZE
)
var initial_energy: int = Globals.ENERGY_PER_SIZE

var _size: float = 1.0:
	set(value):
		_size = value
		mass = value
		var new_scale = pow(value, 1.0 / 3.0)
		
		_update_scale(sprite, new_scale)
		_update_scale(collision, new_scale)

func _ready() -> void:
	_size = float(initial_energy) / Globals.ENERGY_PER_SIZE
	print(name, " is created with energy: ", initial_energy, " Size: ", _size)

func _update_scale(node: Node2D,new_scale: float) -> void:
	if node:
		node.scale = Vector2.ONE * new_scale

func _add_energy(amount: int) -> void:
	assert(amount >= 0, "Energy amount cannot be negative")
	_energy += amount
	_cumulative_energy += amount
	if _energy > _size * Globals.ENERGY_PER_SIZE:
		_size = float(_energy) / Globals.ENERGY_PER_SIZE

func _remove_energy(amount: int) -> void:
	assert(amount >= 0, "Energy amount cannot be negative")
	_energy -= amount
