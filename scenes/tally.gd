class_name TallyInt extends Object

var _cumulative: int = 0

var _peak: int = 0

var current: int = 0:
	set(value):
		value = max(0, value)
		if value > current:
			_cumulative += value - current
		if value > _peak:
			_peak = value
		current = value

var cumulative: int:
	get():
		return _cumulative
	set(value):
		push_error("Cumulative is read only")

var peak: int:
	get():
		return _peak
	set(value):
		push_error("Peak is read only")

func _init(curr: int = 0, cumu: int = 0):
	current = curr
	_cumulative = max(curr, cumu)

func equal(other: TallyInt) -> bool:
	return current == other.current && _cumulative == other._cumulative

func clone() -> TallyInt:
	return TallyInt.new(current, cumulative)

func split() -> TallyInt:
	var cur: int = int(current / 2.0)
	var cumu: int = int(cumulative / 2.0)
	
	var other: TallyInt = TallyInt.new(current - cur, _cumulative - cumu)
	current = cur
	_cumulative = cumu
	_peak = cur
	return other

func add(value: int) -> int:
	value = max(0, value)
	current += value
	return value;

func remove(value: int) -> int:
	value = clampi(value, 0, current)
	current -= value
	return value

func fade(value: int) -> int:
	if current == 0:
		value = clamp(value, 0, cumulative)
		_cumulative -= value
	else:
		value = 0
	return value
