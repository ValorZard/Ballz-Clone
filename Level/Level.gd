extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# update over time i think
var current_row : int = 0
export var num_of_blocks_in_row : int = 8
export var space_between_bricks : int = 120
export var space_between_rows : int = 100
var brick_template : PackedScene = preload("res://Level/Brick.tscn")
var ball_block_template : PackedScene = preload("res://Ball/BallBlock.tscn")

# save game over screen here
var game_over_screen : PackedScene = preload("res://Menu/GameOver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# spawn initial row
	_spawn_row()
	
	# if the ball hit the ground, spawn next row
	GameManager.connect("all_balls_grounded", self, "_setup_next_round")
	GameManager.connect("brick_hit_ground", self, "game_over")

func _generate_row_array() -> Array:
	var i := 0
	var row_array : Array = Array()
	while(i < num_of_blocks_in_row):
		if (randi() % 2 == 0):
			row_array.append(true)
		else:
			row_array.append(false)
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
	var brick_array := Array()
	for brick_pos in row_array:
		if brick_pos == true:
			var brick := brick_template.instance()
			$Bricks.add_child(brick)
			brick.position = Vector2(space_between_bricks * i, 0)
			brick.row = current_row
			brick.set_health(current_row + 1)
			brick_array.append(brick)
		i += 1
	
	# pick random brick from brick array to turn into ball
	var length : int = len(brick_array)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var ball_block_pos = rng.randi_range(0, length - 1)
	
	# store old position to replace with the ball
	var old_pos : Vector2 = brick_array[ball_block_pos].position
	brick_array[ball_block_pos].queue_free()
	brick_array.pop_at(ball_block_pos)
	
	# create ball block and put it in old position
	var ball_block := ball_block_template.instance()
	$Bricks.add_child(ball_block)
	ball_block.position = old_pos
	
	current_row += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RowLabel.text = str(current_row)

func game_over():
	GameManager.score = current_row
	get_tree().change_scene("res://Menu/GameOver.tscn")
