class_name Algae extends Particle

const ALGAE_SCENE: PackedScene = preload("res://scenes/algae/algae.tscn")

var split_energy: int = 2 * 10e3
var alive: bool = true:
	set(value):
		alive = value
		if not alive and sprite:
			sprite.modulate = Color(1.0,1.0,1.0,0.5)

func _process(delta: float) -> void:
	if alive:
		energy += _suckEnergy(delta * 10e3)
		energy -= delta * 10e2
		if energy >= split_energy:
			split()
		if energy <= 0:
			alive = false
	else:
		if _cumulative_energy > 0:
			_cumulative_energy -= _rot(delta * 10e2)
		else:
			queue_free()

func _suckEnergy(amount: int) -> int:
	if current_area:
		amount = clampi(amount, 0, current_area.energy)
		current_area.energy -= amount
		return amount
	else:
		return 0

func _rot(amount: int) -> int:
	if current_area:
		amount = clampi(amount, 0, _cumulative_energy)
		current_area.energy += amount
		return amount
	else:
		return 0

func split() -> void:
	half()
	var new_algae = ALGAE_SCENE.instantiate()
	new_algae.position.x = position.x + 10.0
	new_algae.position.y = position.y + 10.0
	new_algae.rotation = rotation - PI
	new_algae.energy = energy
	apply_impulse(Vector2.UP.rotated(rotation) * 10e1 * mass)
	apply_torque_impulse(randf_range(-10e2, 10e2))
	get_parent().add_child(new_algae)
	new_algae.apply_impulse(Vector2.UP.rotated(new_algae.rotation) * 10e1 * new_algae.mass)
	new_algae.apply_torque_impulse(randf_range(-10e2, 10e2))
