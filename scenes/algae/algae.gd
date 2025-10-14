class_name Algae extends Organism

const ALGAE_SCENE: PackedScene = preload("res://scenes/algae/algae.tscn")

var split_energy: int = 2 * 10e3

func _process(delta: float) -> void:
	if isAlive():
		energy += _suckEnergy(delta * 10e3)
		energy -= delta * 10e2
		if energy >= split_energy:
			split(ALGAE_SCENE)
		if energy <= 0:
			die()
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
