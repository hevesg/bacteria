class_name Game extends Node2D

@onready var areas: Node2D = $PetriDish/Areas
@onready var algaeContainer: AlgaeContainer = $PetriDish/AlgaeContainer

@onready var algaeNumber: DefinitionListItem = $AlgaeNumber
@onready var algaeAliveNumber: DefinitionListItem = $AlgaeAliveNumber
@onready var algaeDeadNumber: DefinitionListItem = $AlgaeDeadNumber
@onready var algaeEnergy: DefinitionListItem = $AlgaeEnergy
@onready var algaeCumulative: DefinitionListItem = $AlgaeCumulative

func _on_timer_timeout() -> void:
	var number = algaeContainer.get_child_count()
	algaeNumber.description_text = number
	
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
	
	algaeEnergy.description_text = total_energy
	algaeCumulative.description_text = total_cumulative_energy
	algaeAliveNumber.description_text = alive
	algaeDeadNumber.description_text = dead
