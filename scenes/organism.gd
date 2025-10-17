class_name Organism extends Particle

var _alive: bool = true:
	set(value):
		_alive = value
		if not _alive and sprite:
			sprite.modulate = Color(1.0,1.0,1.0,0.5)

func isAlive() -> bool:
	return _alive

func isDead() -> bool:
	return not _alive

func die() -> void:
	_alive = false

func jet(directional_strength: float, torque_strength: float = 0.0) -> void:
	apply_impulse(Vector2.UP.rotated(rotation) * directional_strength)
	apply_torque_impulse(torque_strength)
	
func split() -> void:
	if get_parent().spawn:
		var new_organism = get_parent().spawn(
			Vector2(position.x + 10.0, position.y + 10),
			rotation - PI,
			half()
		)
		new_organism.jet(
			Globals.HUNDRED * new_organism.mass,
			randf_range(-Globals.HUNDRED, Globals.HUNDRED) * new_organism.mass
		)

func _rot(amount: int) -> int:
	if current_area:
		amount = clampi(amount, 0, _cumulative_energy)
		current_area.energy += amount
		_cumulative_energy -= amount
		return amount
	else:
		return 0
