@tool
extends Node2D

@export var star_points: int = 5:
	set(value):
		star_points = max(3, value)
		queue_redraw()

@export var outer_radius: float = 12.0:
	set(value):
		outer_radius = max(0.0, value)
		queue_redraw()

@export var inner_radius: float = 6.0:
	set(value):
		inner_radius = clamp(value, 0.0, outer_radius)
		queue_redraw()

@export var star_color: Color = Color(1.0, 0.84, 0.0, 1.0):
	set(value):
		star_color = value
		queue_redraw()

@export var outline_color: Color = Color(1.0, 1.0, 1.0, 0.85):
	set(value):
		outline_color = value
		queue_redraw()

@export var outline_width: float = 1.5:
	set(value):
		outline_width = max(0.0, value)
		queue_redraw()

@export var edge_radius: float = 0.0:
	set(value):
		edge_radius = max(0.0, value)
		queue_redraw()

func _ready() -> void:
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		queue_redraw()

func _draw() -> void:
	if star_points < 3:
		return

	var base_points := _build_star_vertices()
	if base_points.size() < 3:
		return

	var polygon_points := _build_rounded_polygon(base_points)

	if polygon_points.size() >= 3:
		draw_polygon(polygon_points, PackedColorArray([star_color]))

	if outline_width > 0.0:
		var outline_points := polygon_points.duplicate()
		outline_points.append(outline_points[0])
		draw_polyline(outline_points, outline_color, outline_width, true)

func _build_star_vertices() -> Array[Vector2]:
	var vertices: Array[Vector2] = []
	var total_vertices := star_points * 2
	var start_angle := -PI * 0.5
	var angle_step := PI / star_points

	for i in range(total_vertices):
		var radius := outer_radius if i % 2 == 0 else inner_radius
		var angle := start_angle + angle_step * i
		vertices.append(Vector2(cos(angle), sin(angle)) * radius)

	return vertices

func _build_rounded_polygon(base_points: Array[Vector2]) -> PackedVector2Array:
	if edge_radius <= 0.0:
		return PackedVector2Array(base_points)

	var rounded: PackedVector2Array = PackedVector2Array()
	var total: int = base_points.size()

	for i in range(total):
		var current: Vector2 = base_points[i]
		var prev: Vector2 = base_points[(i - 1 + total) % total]
		var nxt: Vector2 = base_points[(i + 1) % total]

		var to_prev: Vector2 = current - prev
		var to_next: Vector2 = nxt - current
		var len_prev: float = to_prev.length()
		var len_next: float = to_next.length()

		if len_prev == 0.0 or len_next == 0.0:
			rounded.append(current)
			continue

		var max_corner_radius: float = min(len_prev, len_next) * 0.5
		var radius: float = min(edge_radius, max_corner_radius)

		if radius <= 0.0:
			rounded.append(current)
			continue

		var in_dir: Vector2 = to_prev / len_prev
		var out_dir: Vector2 = to_next / len_next

		var angle_cos: float = clamp((-in_dir).dot(out_dir), -0.99999, 0.99999)
		var theta: float = acos(angle_cos)
		if is_nan(theta) or theta == 0.0:
			rounded.append(current)
			continue

		var tangent_len: float = radius / tan(theta * 0.5)
		tangent_len = min(tangent_len, len_prev, len_next)
		radius = tangent_len * tan(theta * 0.5)

		var entry_point: Vector2 = current - in_dir * tangent_len
		var exit_point: Vector2 = current + out_dir * tangent_len

		rounded.append(entry_point)

		var segments: int = max(2, int(max(radius, 1.0) * 0.5) + 1)
		for s in range(1, segments):
			var t: float = float(s) / float(segments)
			rounded.append(_quadratic_bezier(entry_point, current, exit_point, t))

		rounded.append(exit_point)

	return rounded

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var u: float = 1.0 - t
	return u * u * p0 + 2.0 * u * t * p1 + t * t * p2
