class_name Game extends Node2D

@onready var areas: Node2D = $PetriDish/Areas
@onready var algaeContainer: AlgaeContainer = $PetriDish/AlgaeContainer

@onready var areaEnergy: DefinitionListItem = $AreaEnergy

@onready var algaeNumber: DefinitionListItem = $AlgaeNumber
@onready var algaeAliveNumber: DefinitionListItem = $AlgaeAliveNumber
@onready var algaeDeadNumber: DefinitionListItem = $AlgaeDeadNumber
@onready var algaeEnergy: DefinitionListItem = $AlgaeEnergy
@onready var algaeCumulative: DefinitionListItem = $AlgaeCumulative

func _on_timer_timeout() -> void:
	var number = algaeContainer.get_child_count()
	algaeNumber.description_text = number
	
	var area_total_energy = 0
	var total_energy = 0
	var total_cumulative_energy = 0
	var alive = 0
	var dead = 0
	
	for algae in algaeContainer.get_children():
		if algae is Algae:
			total_energy += algae.energy
			total_cumulative_energy += algae._cumulative_energy
			if algae.isAlive():
				alive += 1
			else:
				dead += 1
	
	for area in areas.get_children():
		if area is DishArea:
			area_total_energy += area.energy
	
	algaeEnergy.description_text = total_energy
	algaeCumulative.description_text = total_cumulative_energy
	algaeAliveNumber.description_text = alive
	algaeDeadNumber.description_text = dead
	areaEnergy.description_text = area_total_energy
