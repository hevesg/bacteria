class_name Game extends Node2D

@onready var areas: Node2D = $PetriDish/Areas
@onready var algaeContainer: AlgaeContainer = $PetriDish/AlgaeContainer

@onready var algaeNumber: KeyValueInfo = $AlgaeNumber
@onready var algaeAliveNumber: KeyValueInfo = $AlgaeAliveNumber
@onready var algaeDeadNumber: KeyValueInfo = $AlgaeDeadNumber
@onready var algaeEnergy: KeyValueInfo = $AlgaeEnergy
@onready var algaeCumulative: KeyValueInfo = $AlgaeCumulative

func _on_timer_timeout() -> void:
	var number = algaeContainer.get_child_count()
	algaeNumber.info_value = number
	
	var total_energy = 0
	var total_cumulative_energy = 0
	var alive = 0
	var dead = 0
	
	for child in algaeContainer.get_children():
		if child is Algae:
			total_energy += child.energy
			total_cumulative_energy += child._cumulative_energy
			if child.isAlive():
				alive = alive + 1
			else:
				dead = dead + 1
	
	algaeEnergy.info_value = total_energy
	algaeCumulative.info_value = total_cumulative_energy
	algaeAliveNumber.info_value = alive
	algaeDeadNumber.info_value = dead
