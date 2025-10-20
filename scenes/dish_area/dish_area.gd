@tool
class_name DishArea extends Area2D

@onready
var sprite: Sprite2D = $Sprite

@export
var energy: int = 0:
	set(value):
		energy = value
		if sprite:
			sprite.modulate = Color(
				1.0,
				1.0,
				1.0,
				float(energy) / Globals.MILLION
			)
	
func transfer_energy_to(amount: int, area: DishArea) -> void:
	amount = clampi(amount, 0, energy)
	energy -= amount
	area.energy += amount

func get_random_position() -> Vector2:
	if sprite:
		return Globals.get_random_point_of(sprite.get_rect()) / 2.0
	else:
		return Vector2()

func _on_body_entered(body: Node2D) -> void:
	if body is Particle:
		body.current_area = self
