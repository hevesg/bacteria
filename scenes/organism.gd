class_name Organism extends Particle

var _split_energy: int = Globals.BILLION

var _alive: bool = true:
	set(value):
		_alive = value
		if not _alive and sprite:
			sprite.modulate = Color(1.0,1.0,1.0,0.5)

func is_alive() -> bool:
	return _alive

func is_dead() -> bool:
	return not _alive

func die() -> void:
	_alive = false

func set_split_energy(amount: int) -> void:
	_split_energy = amount

func _process(delta: float) -> void:
	if is_dead():
		if _cumulative_energy > 0:
			_rot(int(delta * Globals.TEN_THOUSAND))
		else:
			queue_free()
	else:
		energy -= int(delta * Globals.THOUSAND)
		if energy >= _split_energy:
			split()
		if energy <= 0:
			die()

func jet(directional_strength: float, torque_strength: float = 0.0) -> void:
	apply_impulse(Vector2.UP.rotated(rotation) * directional_strength)
	apply_torque_impulse(torque_strength)
	
func split() -> void:
	if get_parent().spawn:
		var _half = half()
		var new_organism = get_parent().spawn(
			position,
			rotation - PI,
			_half[0],
			_half[1]
		)
		position += Vector2.UP.rotated(rotation) * 10.0
		new_organism.position += Vector2.UP.rotated(new_organism.rotation) * 10.0
		new_organism.jet(
			Globals.HUNDRED * new_organism.mass,
			randf_range(-Globals.HUNDRED, Globals.HUNDRED) * new_organism.mass
		)
		jet(
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
