@tool
class_name DefinitionListItem extends Control

@onready var title: Label = $Title
@onready var description: Label = $Description

@export
var title_text: String = 'Title':
	set(value):
		title_text = str(value)
		if title:
			title.text = str(value)
	
@export
var description_text = '':
	set(value):
		description_text = value
		if description:
			if value is int:
				description.text = _format_number(value)
			else:
				description.text = str(value)

func _ready() -> void:
	if title:
		title.text = str(title_text)
	if description:
		if description_text is int:
			description.text = _format_number(description_text)
		else:
			description.text = str(description_text)

func _format_number(number: int) -> String:
	var number_str = str(number)
	var formatted = ""
	var count = 0
	
	for i in range(number_str.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			formatted = " " + formatted
		formatted = number_str[i] + formatted
		count += 1
		
	return formatted
