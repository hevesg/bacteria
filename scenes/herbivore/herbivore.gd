@tool
class_name Herbivore extends Organism

func _ready() -> void:
	super._ready()
	set_split_energy(2 * Globals.MILLION)

func _process(delta: float) -> void:
	super._process(delta)
	if is_alive():
		pass

func _on_timer_timeout() -> void:
	jet(randf_range(1000, 3000), randf_range(-5000, 5000))


func _on_body_entered(body: Node) -> void:
	if (body is Algae and body.is_dead()):
		print("dead animal found")
