class_name Game extends Node2D

@onready var areas: Node2D = $PetriDish/Areas
@onready var algae_container: AlgaeContainer = $PetriDish/AlgaeContainer

@onready var area_energy_info: DefinitionListItem = $AreaEnergy

@onready var algae_total_info: DefinitionListItem = $AlgaeNumber
@onready var algae_alive_info: DefinitionListItem = $AlgaeAliveNumber
@onready var algae_dead_info: DefinitionListItem = $AlgaeDeadNumber
@onready var algae_energy_total_info: DefinitionListItem = $AlgaeEnergy
@onready var algae_cumulative_total_info: DefinitionListItem = $AlgaeCumulative
@onready var total_energy_info: DefinitionListItem = $TotalEnergy

func _on_timer_timeout() -> void:
	var number = algae_container.get_child_count()
	algae_total_info.description_text = number
	
	var area_total_energy = 0
	var total_energy = 0
	var total_cumulative_energy = 0
	var alive = 0
	var dead = 0
	
	for algae in algae_container.get_children():
		if algae is Algae:
			total_energy += algae.energy
			total_cumulative_energy += algae._cumulative_energy
			if algae.is_alive():
				alive += 1
			else:
				dead += 1
	
	for area in areas.get_children():
		if area is DishArea:
			area_total_energy += area.energy
	
	algae_energy_total_info.description_text = total_energy
	algae_cumulative_total_info.description_text = total_cumulative_energy
	algae_alive_info.description_text = alive
	algae_dead_info.description_text = dead
	area_energy_info.description_text = area_total_energy
	total_energy_info.description_text = total_cumulative_energy + area_total_energy
