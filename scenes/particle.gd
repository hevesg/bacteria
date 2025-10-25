class_name Particle extends RigidBody2D

@onready
var collision: CollisionShape2D = $Collision

@onready
var sprite: Sprite2D = $Sprite

var energy: TallyInt = TallyInt.new()

func init_particle(current_energy: int, cumulative_energy: int) -> void:
	energy = TallyInt.new(current_energy, cumulative_energy)
	_set_mass()

func set_energy(value: int) -> void:
	energy.current = value
	_set_mass()

func half_energy() -> TallyInt:
	var value = energy.split()
	_set_mass()
	return value

var current_area: DishArea = null:
	set(value):
		if current_area:
			current_area.transfer_energy_to(
				int(force * Globals.ENERGY_TRANSFER_AMOUNT),
				value
			)
		current_area = value

var force: float:
	get():
		return linear_velocity.length() * mass

func _ready() -> void:
	gravity_scale = 0
	linear_damp = 1

func _update_scale(node: Node2D, new_scale: float) -> void:
	if node:
		node.scale = Vector2.ONE * new_scale

func _set_mass() -> void:
	var value = float(energy.peak) / Globals.ENERGY_PER_SIZE
	if energy.peak > mass:
		mass = value
		var new_scale = pow(mass, 1.0 / 3.0)
		_update_scale(sprite, new_scale)
		_update_scale(collision, new_scale)
