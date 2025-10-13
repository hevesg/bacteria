@tool
class_name Herbivore extends Particle

func jet(force_strength: float, torque_strength: float = 0.0) -> void:
	apply_impulse(Vector2.UP.rotated(rotation) * force_strength)
	apply_torque_impulse(torque_strength)

func _on_timer_timeout() -> void:
	jet(randf_range(1000, 3000), randf_range(-5000, 5000))

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		_add_energy(int(delta * 100))
