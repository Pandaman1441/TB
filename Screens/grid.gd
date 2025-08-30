extends TileMap

@export var cell_size: int = 32
@export var width: int = 10
@export var height: int = 10
var occupancy := {}  # maps Vector2i -> Archetype

func world_to_cell(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos.x / cell_size), floor(pos.y / cell_size))

func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(cell.x * cell_size, cell.y * cell_size)

func is_reachable(unit: Archetype, cell: Vector2i, range: int) -> bool:
	var origin := world_to_cell(unit.position)
	return origin.distance_to(cell) <= range and not occupancy.has(cell)

func move_unit(unit: Archetype, cell: Vector2i) -> void:
	var old := world_to_cell(unit.position)
	occupancy.erase(old)
	occupancy[cell] = unit
	unit.position = cell_to_world(cell)

func distance_units(a: Archetype, b: Archetype) -> int:
	return world_to_cell(a.position).distance_to(world_to_cell(b.position))
