class_name Organism extends Particle

var _energy_when_split: int = Globals.BILLION

var _alive: bool = true:
	set(value):
		_alive = value
		if not _alive and sprite:
			sprite.modulate = Color(1.0,1.0,1.0,0.5)

var is_alive: bool:
	get():
		return _alive

var is_dead: bool:
	get():
		return not _alive

func init_organism(
	current_energy: int,
	cumulative_energy: int,
	energy_when_split: int
) -> void:
	super.init_particle(current_energy, cumulative_energy)
	_energy_when_split = energy_when_split

func die() -> void:
	_alive = false

func set_energy_when_split(amount: int) -> void:
	_energy_when_split = max(energy.current, amount)

func _ready():
	super._ready()

func _process(delta: float) -> void:
	if is_dead:
		if energy.cumulative > 0:
			_rot_to_area(int(delta * Globals.TEN_THOUSAND))
		else:
			queue_free()
	else:
		energy.remove(int(delta * Globals.THOUSAND))
		if energy.current >= _energy_when_split:
			split()
		if energy.current <= 0:
			die()

func jet(directional_strength: float, torque_strength: float = 0.0, burn_energy: bool = false) -> void:
	apply_impulse(Vector2.UP.rotated(rotation) * directional_strength)
	apply_torque_impulse(torque_strength)
	if burn_energy:
		energy.remove(int(directional_strength))
	
func split() -> void:
	if get_parent().spawn:
		var half = energy.split()
		var new_organism = get_parent().spawn(
			position,
			rotation - PI,
			half.current,
			half.cumulative,
			_energy_when_split
		)
		position += Vector2.UP.rotated(rotation) * 10.0
		new_organism.position += Vector2.UP.rotated(new_organism.rotation) * 10.0
		new_organism.jet(
			Globals.HUNDRED,
			randf_range(-Globals.HUNDRED, Globals.HUNDRED)
		)
		jet(
			Globals.HUNDRED,
			randf_range(-Globals.HUNDRED, Globals.HUNDRED)
		)
		

func _rot_to_area(value: int) -> int:
	if current_area:
		value = energy.fade(value)
		current_area.energy += value
		return value
	else:
		return 0
