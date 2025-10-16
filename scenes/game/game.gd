class_name Game extends Node2D

@onready var algaeNumber: Label = $AlgaeNumber
@onready var algaeEnergy: Label = $AlgaeEnergy
@onready var algaeCumulative: Label = $AlgaeCumulative

func _on_timer_timeout() -> void:
	var number = get_child_count() - 5
	algaeNumber.text = str(number)
	
	var total_energy = 0
	var total_cumulative_energy = 0
	
	for child in get_children():
		if child is Algae:
			total_energy += child.energy
			total_cumulative_energy += child._cumulative_energy
	
	algaeEnergy.text = str(total_energy)
	algaeCumulative.text = str(total_cumulative_energy)
