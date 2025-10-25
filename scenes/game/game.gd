class_name Game extends Node2D

@onready var petriDish: PetriDish = $PetriDish
@onready var areas: Node2D = $PetriDish/Areas
@onready var algae_container: OrganismContainer = $PetriDish/AlgaeContainer
@onready var herbivore_container: OrganismContainer = $PetriDish/HerbivoreContainer

@onready var algae_info_panel := $AlgaeInfoPanel
@onready var area_energy_info: DefinitionListItem = $AreaEnergy

@onready var herbivore_energy_total_info: DefinitionListItem = $HerbivoreEnergy
@onready var herbivore_cumulative_total_info: DefinitionListItem = $HerbivoreCumulative

@onready var total_energy_info: DefinitionListItem = $TotalEnergy

func _on_timer_timeout() -> void:
	algae_info_panel.total_value.text = Globals.format_number(algae_container.get_child_count())
	
	var area_total_energy = 0
	
	var total_algae_energy = 0
	var total_algae_cumulative_energy = 0
	var algae_alive = 0
	var algae_dead = 0
	
	var total_herbivore_energy = 0
	var total_herbivore_cumulative_energy = 0
	
	for herbivore in herbivore_container.get_children():
		if herbivore is Herbivore:
			total_herbivore_energy += herbivore.energy.current
			total_herbivore_cumulative_energy += herbivore.energy.cumulative
	
	for algae in algae_container.get_children():
		if algae is Algae:
			total_algae_energy += algae.energy.current
			total_algae_cumulative_energy += algae.energy.cumulative
			if algae.is_alive:
				algae_alive += 1
			else:
				algae_dead += 1
	
	for area in areas.get_children():
		if area is DishArea:
			area_total_energy += area.energy
	
	herbivore_energy_total_info.description_text = total_herbivore_energy
	herbivore_cumulative_total_info.description_text = total_herbivore_cumulative_energy
	
	algae_info_panel.current_energy_value.text = Globals.format_number(total_algae_energy)
	algae_info_panel.cumulative_energy_value.text = Globals.format_number(total_algae_cumulative_energy)
	algae_info_panel.alive_value.text = Globals.format_number(algae_alive)
	algae_info_panel.dead_value.text = Globals.format_number(algae_dead)
	
	area_energy_info.description_text = area_total_energy
	total_energy_info.description_text = total_algae_cumulative_energy + area_total_energy + total_herbivore_cumulative_energy


func _on_herbivore_drop(mouse_position: Vector2) -> void:
	var pos = mouse_position - petriDish.position
	herbivore_container.spawn(
		pos,
		randf() * PI * 2,
		Globals.MILLION,
		Globals.MILLION,
		2 * Globals.MILLION
	)
