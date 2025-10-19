class_name Algae extends Organism

func _ready() -> void:
	super._ready()
	set_split_energy(2 * Globals.HUNDRED_THOUSAND)

func _process(delta: float) -> void:
	super._process(delta)
	if is_alive():
		_suckEnergy(int(delta * Globals.TEN_THOUSAND))

func _suckEnergy(amount: int) -> int:
	if current_area:
		amount = clampi(amount, 0, current_area.energy)
		current_area.energy -= amount
		energy += amount
		return amount
	else:
		return 0
