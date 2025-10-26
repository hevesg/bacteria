@tool
extends PanelContainer

@onready var title_value = $MarginContainer/VBoxContainer/Title
@onready var total_value = $MarginContainer/VBoxContainer/AlgaeNumber/TotalValue
@onready var alive_value = $MarginContainer/VBoxContainer/AlgaeNumber/AliveValue
@onready var dead_value = $MarginContainer/VBoxContainer/AlgaeNumber/DeadValue
@onready var current_energy_value = $MarginContainer/VBoxContainer/BioMass/CurrentEnergyValue
@onready var cumulative_energy_value = $MarginContainer/VBoxContainer/BioMass/CumulativeEnergyValue

@export
var title: String = 'Title':
	set(value):
		title = value
		_update_title_display()

@export
var container: OrganismContainer

func _ready() -> void:
	_update_title_display()
	_update_data_display()

func _update_title_display() -> void:
	if title_value:
		title_value.text = title

func _update_data_display() -> void:
	if container:
		var total_current_energy: int = 0
		var total_cumulative_energy: int = 0
		var total_alive: int = 0
		var total_dead: int = 0
		
		for organism in container.get_children():
			if organism is Organism:
				total_current_energy += organism.energy.current
				total_cumulative_energy += organism.energy.cumulative
				if organism.is_alive:
					total_alive += 1
				else:
					total_dead += 1
	
		total_value.text = Globals.format_number(total_alive + total_dead)
		alive_value.text = Globals.format_number(total_alive)
		dead_value.text = Globals.format_number(total_dead)
		
		current_energy_value.text = Globals.format_number(total_current_energy)
		cumulative_energy_value.text = Globals.format_number(total_cumulative_energy)

func _on_timer_timeout() -> void:
	_update_data_display()
