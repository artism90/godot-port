extends GridMap

signal cell_item_changed

#        -z
#        / \
#         |
#       .....
# <- -x ..... +x ->
#       .....
#         |
#        \ /
#        +z
const TILE_OFFSETS = {
	# Direct connections
	"a": [ 0, -1],
	"b": [+1,  0],
	"c": [ 0, +1],
	"d": [-1,  0],
	# Remote connections
	"e": [+1, -1],
	"f": [+1, +1],
	"g": [-1, +1],
	"h": [-1, -1],
}

const TILE_SETS = {
	"single": {"item": 0, "rotation": 0},

	"a": {"item": 1, "rotation": 270},
	"b": {"item": 1, "rotation": 180},
	"c": {"item": 1, "rotation": 90},
	"d": {"item": 1, "rotation": 0},

	"ab": {"item": 2, "rotation": 270},
	"bc": {"item": 2, "rotation": 180},
	"cd": {"item": 2, "rotation": 90},
	"ad": {"item": 2, "rotation": 0},

	"abc": {"item": 3, "rotation": 270},
	"bcd": {"item": 3, "rotation": 180},
	"acd": {"item": 3, "rotation": 90},
	"abd": {"item": 3, "rotation": 0},

	"abcd": {"item": 4, "rotation": 0},

	"abcde": {"item": 5, "rotation": 270},
	"abcdf": {"item": 5, "rotation": 180},
	"abcdg": {"item": 5, "rotation": 90},
	"abcdh": {"item": 5, "rotation": 0},

	"abcdef": {"item": 6, "rotation": 270},
	"abcdfg": {"item": 6, "rotation": 180},
	"abcdgh": {"item": 6, "rotation": 90},
	"abcdeh": {"item": 6, "rotation": 0},

	"abcdefg": {"item": 7, "rotation": 270},
	"abcdfgh": {"item": 7, "rotation": 180},
	"abcdegh": {"item": 7, "rotation": 90},
	"abcdefh": {"item": 7, "rotation": 0},

	"abcdefgh": {"item": 8, "rotation": 0},

	"abcdeg": {"item": 9, "rotation": 90},
	"abcdfh": {"item": 9, "rotation": 0},

	"abce": {"item": 10, "rotation": 270},
	"bcdf": {"item": 10, "rotation": 180},
	"acdg": {"item": 10, "rotation": 90},
	"abdh": {"item": 10, "rotation": 0},

	"abcef": {"item": 11, "rotation": 270},
	"bcdfg": {"item": 11, "rotation": 180},
	"acdgh": {"item": 11, "rotation": 90},
	"abdeh": {"item": 11, "rotation": 0},

	"abcf": {"item": 12, "rotation": 270},
	"bcdg": {"item": 12, "rotation": 180},
	"acdh": {"item": 12, "rotation": 90},
	"abde": {"item": 12, "rotation": 0},

	"abe": {"item": 13, "rotation": 270},
	"bcf": {"item": 13, "rotation": 180},
	"cdg": {"item": 13, "rotation": 90},
	"adh": {"item": 13, "rotation": 0},

	"ac": {"item": 14, "rotation": 90},
	"bd": {"item": 14, "rotation": 0},
}

func _ready() -> void:
	update_tiles()

func update_tiles(scaffold_tiles: Array = [], can_built := true) -> void:
	#prints(get_node("..").get_children())
	#var sprite = get_node("../../TileMarker") #Sprite3D.new()
	#add_child(sprite)

	#sprite.show()
	for cell in get_used_cells():
		#sprite.global_transform.origin = map_to_world(cell.x, cell.y, cell.z)
		#cell = map_3_to_2(cell)
		#prints("current cell:\t", cell)

		var tile_set = ""
		for tile_offset in TILE_OFFSETS:
			#prints("check for tile_offset:\t", TILE_OFFSETS[tile_offset])

			#yield(get_tree().create_timer(.1), "timeout")
			var checked_tile = get_cell_item(cell.x + TILE_OFFSETS[tile_offset][0], 0, cell.z + TILE_OFFSETS[tile_offset][1])
			if checked_tile > -1: # Is there a road?
				if tile_offset in "abcd":
					tile_set += tile_offset
				if tile_offset in "efgh":
					var fill_left = char(ord(tile_offset) - 4) in tile_set

					var fill_right = char(ord(tile_offset) - 3 - 4 * int(tile_offset == "h")) in tile_set
					if fill_left and fill_right:
						tile_set += tile_offset

		#print("tile set for position {0}: {1}".format([cell, tile_set]))
		if tile_set in [""]:
			tile_set = "single"

		var quaternion = Quat(Vector3(0, 1, 0), deg2rad(TILE_SETS[tile_set]["rotation"]))
		var cell_item_orientation = Basis(quaternion).get_orthogonal_index()

		var item: int = TILE_SETS[tile_set]["item"]
		if Vector3(cell.x, cell.y, cell.z) in scaffold_tiles:
			if can_built:
				item += 15
			else:
				item += 15 * 2

		set_cell_item(cell.x, cell.y, cell.z, item, cell_item_orientation)

	#yield(get_tree().create_timer(2), "timeout")
	#sprite.hide()

func map_3_to_2(vec3: Vector3) -> Vector2:
	return Vector2(vec3.x, vec3.z)
