class_name Herbivore extends Organism

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	if is_alive:
		pass

func _on_timer_timeout() -> void:
	if is_alive:
		jet(randf_range(1000.0, 3000.0), randf_range(-5000, 5000), true)

func _on_body_entered(body: Node) -> void:
	if body is Algae and body.is_dead and is_alive:
		set_energy(energy.current + body.energy.cumulative)
		body.queue_free()
