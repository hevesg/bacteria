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

func _ready() -> void:
	_update_title_display()

func _update_title_display() -> void:
	if title_value:
		title_value.text = title
