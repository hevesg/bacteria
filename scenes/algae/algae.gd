class_name Algae extends Organism

var split_energy: int = 2 * Globals.HUNDRED_THOUSAND

func _process(delta: float) -> void:
	if isAlive():
		_suckEnergy(int(delta * Globals.TEN_THOUSAND))
		energy -= int(delta * Globals.THOUSAND)
		if energy >= split_energy:
			split()
		if energy <= 0:
			die()
	else:
		if _cumulative_energy > 0:
			_rot(int(delta * Globals.TEN_THOUSAND))
		else:
			queue_free()

func _suckEnergy(amount: int) -> int:
	if current_area:
		amount = clampi(amount, 0, current_area.energy)
		current_area.energy -= amount
		energy += amount
		return amount
	else:
		return 0
