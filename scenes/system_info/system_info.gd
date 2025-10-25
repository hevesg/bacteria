extends PanelContainer

@onready var fps := $MarginContainer/GridContainer/FpsValue
@onready var static_memory_value := $MarginContainer/GridContainer/StaticMemoryValue
@onready var static_memory_max_value := $MarginContainer/GridContainer/StaticMemoryMaxValue
@onready var object_count_value := $MarginContainer/GridContainer/ObjectCountValue

func _on_timer_timeout() -> void:
	fps.text = _convert_value(Performance.get_monitor(Performance.TIME_FPS))
	static_memory_value.text = _convert_value(Performance.get_monitor(Performance.MEMORY_STATIC))
	static_memory_max_value.text = _convert_value(Performance.get_monitor(Performance.MEMORY_STATIC_MAX))
	object_count_value.text = _convert_value(Performance.get_monitor(Performance.OBJECT_COUNT))

func _convert_value(value: float) -> String:
	return str(Globals.format_number(int(value)))
