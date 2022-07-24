extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# update over time i think
var current_row : int = 1
export var num_of_blocks_in_row : int = 8
export var space_between_bricks : int = 120
export var space_between_rows : int = 100
var brick_template : PackedScene = preload("res://Level/Brick.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# spawn initial row
	_spawn_row()
	
	# if the ball hit the ground, spawn next row
	GameManager.connect("hit_ground", self, "_setup_next_round")

func _generate_row_array() -> Array:
	var i := 0
	var row_array : Array = Array()
	while(i < num_of_blocks_in_row):
		row_array.append(true)
		i += 1
	return row_array

func _setup_next_round():
	# move all the Bricks down
	for brick in $Bricks.get_children():
		brick.position.y += space_between_rows
	
	_spawn_row()

func _spawn_row():
	# spawn new row
	var row_array := _generate_row_array()
	var i := 0
	for brick_pos in row_array:
		if brick_pos == true:
			var brick := brick_template.instance()
			$Bricks.add_child(brick)
			brick.position = Vector2(space_between_bricks * i, 0)
			brick.row = current_row
		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
