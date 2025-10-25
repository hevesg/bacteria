extends Node

const ONE: int = int(1)
const TEN: int = int(10)
const HUNDRED: int = int(100)
const THOUSAND: int = int(1_000)
const TEN_THOUSAND: int = int(10_000)
const HUNDRED_THOUSAND: int = int(100_000)
const MILLION: int = int(1_000_000)
const TEN_MILLION: int = int(10_000_000)
const HUNDRED_MILLION: int = int(100_000_000)
const BILLION: int = int(1_000_000_000)
const TEN_BILLION: int = int(10_000_000_000)
const HUNDRED_BILLION: int = int(100_000_000_000)
const TRILLION: int = int(1_000_000_000_000)

const ENERGY_PER_SIZE: int = HUNDRED_THOUSAND
const ENERGY_TRANSFER_AMOUNT: int = HUNDRED

const AREA_SIZE: float = 64.0
const HALF_AREA_SIZE: float = AREA_SIZE / 2

func get_random_point_of(rect: Rect2) -> Vector2:
	return Vector2(
		randf_range(rect.position.x, rect.end.x),
		randf_range(rect.position.y, rect.end.y),
	)

func format_number(number: int) -> String:
	var number_str = str(number)
	var formatted = ""
	var count = 0
	
	for i in range(number_str.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			formatted = " " + formatted
		formatted = number_str[i] + formatted
		count += 1
	
	return formatted
