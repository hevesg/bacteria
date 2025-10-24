extends Panel

@onready var fps := $GridContainer/FpsValue
@onready var static_memory_value := $GridContainer/StaticMemoryValue
@onready var static_memory_max_value := $GridContainer/StaticMemoryMaxValue
@onready var object_count_value := $GridContainer/ObjectCountValue

func _on_timer_timeout() -> void:
	fps.text = str(Performance.TIME_FPS)
	static_memory_value.text = str(Performance.MEMORY_STATIC)
	static_memory_max_value.text = str(Performance.MEMORY_STATIC_MAX)
	object_count_value.text = str(Performance.OBJECT_COUNT)
