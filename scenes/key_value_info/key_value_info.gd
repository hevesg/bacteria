@tool
class_name KeyValueInfo extends Node2D

@onready var label: Label = $Label
@onready var info: Label = $Info

@export var label_text: String = 'Label':
	set(val):
		label_text = str(val)
		if label:
			label.text = str(val)

func _ready() -> void:
	if label:
		label.text = str(label_text)
	if info:
		if info_value is int:
			info.text = _format_number(info_value)
		else:
			info.text = str(info_value)
	
var info_value = '':
	set(value):
		info_value = value
		if info:
			if value is int:
				info.text = _format_number(value)
			else:
				info.text = str(value)

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
