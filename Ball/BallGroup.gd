extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAX_SPEED = 750
const TIME_BETWEEN_BALLS = 0.1
# the leader ball of the group
var lead_ball : Ball
var ball_template : PackedScene = preload("res://Ball/Ball.tscn")
var grounded_balls : Array

const DEBUG = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if DEBUG:
		print("Ball Group Initalized")
	
	GameManager.connect("hit_ground", self, "_on_ball_hit_ground")
	
	# set up lead ball stuff
	lead_ball = get_tree().get_nodes_in_group("balls")[0]
	self.position = lead_ball.position
	if DEBUG:
		print("Ball Group Position ", self.position)
	
	# there should only be one ball at the start, but just in case
	# for this code to properly work, BallGroup has to be lower on the scene tree than the Ball node, since the Ball node didn't properly load yet.
	for ball in get_tree().get_nodes_in_group("balls"):
		grounded_balls.append(ball)
		if DEBUG:
			print("added grounded ball")

func reset_group():
	# set up lead ball stuff
	#lead_ball = get_tree().get_nodes_in_group("balls")[0]
	# remove all balls from grounded in prep to restart
	grounded_balls.clear()
	
	# remove all balls from grounded in prep to restart
	for ball in get_tree().get_nodes_in_group("balls"):
		grounded_balls.append(ball)
		ball.reset_ball()
		ball.position = self.position

func _input(event):
	# once all balls have been grounded, then we can shoot again
	if event.is_action_pressed("shoot"):
#		if DEBUG:
#			print("clicked shoot!")
		if len(grounded_balls) == len(get_tree().get_nodes_in_group("balls")):
			var mouse_direction : Vector2 = get_global_mouse_position() - self.position
			mouse_direction = mouse_direction.normalized()
			_on_ball_shot(mouse_direction)
			# turn label off now that its moving
			$Label.visible = false
			if DEBUG:
				print("balls shot!")

# handle display stuff
func _process(delta : float):
	if len(grounded_balls) == len(get_tree().get_nodes_in_group("balls")):
		# render the direction line
		$DirectionLine.clear_points()
		# needs things in local position
		$DirectionLine.add_point($DirectionLine.to_local(self.position))
		$DirectionLine.add_point($DirectionLine.to_local(get_global_mouse_position()))
		
		# label text
		$Label.text = str(GameManager.num_of_balls)
	else:
		$DirectionLine.clear_points()

func _on_ball_shot(mouse_direction : Vector2):
	# generate all balls from our travels to join the party
	var ball_id := 0
	while(len(get_tree().get_nodes_in_group("balls")) < GameManager.num_of_balls):
			var new_ball := ball_template.instance()
			get_tree().get_root().add_child(new_ball)
			new_ball.position = self.position
			ball_id += 1
			if(DEBUG):
				print("New ball generated: " + str(ball_id))
	
	# clear all balls from grounded in order to take off
	grounded_balls.clear()
	
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.speed = MAX_SPEED
		ball.direction = mouse_direction
		ball.velocity = ball.speed * ball.direction
		ball.current_state = GameManager.BALL_STATE.MOVING
		# remove ball from grounded balls
		grounded_balls.erase(ball)
		# give time to shoot out each ball
		yield(get_tree().create_timer(TIME_BETWEEN_BALLS), "timeout")
	
	GameManager.emit_signal("ball_shoot")

func  _on_ball_hit_ground(ball : Ball):
	# show label text again
	$Label.visible = true
	
	if len(grounded_balls) == 0:
		# set lead ball as the first ball that touches the ground
		self.position = ball.position
		lead_ball = ball
	else:
		# set all other ball positiosn that touch the ground to be the position of the "lead ball"
		ball.position = lead_ball.position
	
	grounded_balls.append(ball)
	
	if(DEBUG):
		print("Grounded Balls :" + str(len(grounded_balls)) 
			+ ", Balls in Scene: " + str(len(get_tree().get_nodes_in_group("balls"))) 
			+ ", Num of Balls according to GM:" + str(GameManager.num_of_balls))
	
	# use amount of balls in scene instead of GameManager, since some of the balls in GameManager havent been generated yet.
	if len(grounded_balls) == len(get_tree().get_nodes_in_group("balls")):
		GameManager.emit_signal("all_balls_grounded")
		if(DEBUG):
			print("All balls returned to the ground")
	

func erase_balls_in_group():
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.queue_free()
