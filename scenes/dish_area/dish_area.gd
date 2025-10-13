class_name DishArea extends Area2D

@onready var sprite: Sprite2D = $Sprite

var initial_energy: int = 0
var _energy: int = 0:
	set(value):
		_energy = value
		sprite.modulate = Color(
			1.0,
			1.0,
			1.0,
			_energy / 10e8)

func transfer_energy_to(amount: int, area: DishArea) -> void:
	amount = clampi(amount, 0, _energy)
	_energy -= amount
	area._energy += amount

func _ready() -> void:
	_energy = initial_energy

func _on_body_entered(body: Node2D) -> void:
	if body is Particle:
		body.current_area = self
