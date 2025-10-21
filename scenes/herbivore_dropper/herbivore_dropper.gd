class_name HerbivoreDropper extends Node2D

@export
var herbivore_scene: PackedScene = preload("res://scenes/herbivore/herbivore.tscn")

@export
var drop_area: Node2D  # The area where herbivores can be dropped

signal on_drop_sprite(mouse_position: Vector2)

var is_dragging: bool = false
var drag_offset: Vector2
var dragged_sprite: Sprite2D = null

func _ready() -> void:
	set_process_input(true)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_start_drag(event.global_position)
			else:
				_end_drag(event.global_position)
	elif event is InputEventMouseMotion and is_dragging:
		_update_drag_position(event.global_position)

func _start_drag(mouse_pos: Vector2) -> void:
	var sprite = $Sprite
	if sprite and _is_point_in_sprite(mouse_pos, sprite):
		is_dragging = true
		drag_offset = mouse_pos - global_position
		
		# Create a sprite for dragging instead of full scene
		dragged_sprite = Sprite2D.new()
		dragged_sprite.texture = sprite.texture
		dragged_sprite.scale = sprite.scale
		dragged_sprite.position = mouse_pos
		dragged_sprite.modulate = Color(1, 1, 1, 0.7)
		get_parent().add_child(dragged_sprite)

func _update_drag_position(mouse_pos: Vector2) -> void:
	if dragged_sprite:
		dragged_sprite.position = mouse_pos

func _end_drag(mouse_pos: Vector2) -> void:
	if is_dragging and dragged_sprite:
		on_drop_sprite.emit(mouse_pos)
		
		dragged_sprite.queue_free()
		dragged_sprite = null
		is_dragging = false

func _is_point_in_sprite(point: Vector2, sprite: Sprite2D) -> bool:
	if not sprite or not sprite.texture:
		return false
	
	var sprite_rect = Rect2(
		sprite.global_position - sprite.texture.get_size() * sprite.scale / 2,
		sprite.texture.get_size() * sprite.scale
	)
	return sprite_rect.has_point(point)

func _is_valid_drop_location(pos: Vector2) -> bool:
	if drop_area:
		return true
	return true
