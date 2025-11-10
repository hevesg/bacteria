class_name Algae extends Organism

func _ready() -> void:
	super._ready()

func on_frame(delta: float) -> void:
	super.on_frame(delta)
	if is_alive:
		_suckEnergy(int(delta * Globals.TEN_THOUSAND))

func _suckEnergy(amount: int) -> int:
	if current_area:
		amount = current_area.remove_energy(amount)
		set_energy(energy.current + amount)
		return amount
	else:
		return 0
