extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAX_SPEED = 400
const TIME_BETWEEN_BALLS = 0.1
# the leader ball of the group
var lead_ball : Ball
var ball_template : PackedScene = preload("res://Ball/Ball.tscn")
var grounded_balls : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("hit_ground", self, "_on_ball_hit_ground")
	lead_ball = get_tree().get_nodes_in_group("balls")[0]
	# there should only be one ball at the start, but just in case
	for ball in get_tree().get_nodes_in_group("balls"):
		grounded_balls.append(ball)

func _input(event):
	# once all balls have been grounded, then we can shoot again
	if len(grounded_balls) == GameManager.num_of_balls:
		if event.is_action_pressed("shoot"):
			var mouse_direction : Vector2 = get_global_mouse_position() - self.position
			mouse_direction = mouse_direction.normalized()
			_on_ball_shot(mouse_direction)
			# turn label off now that its moving
			$Label.visible = false

# handle display stuff
func _process(delta : float):
	if len(grounded_balls) == GameManager.num_of_balls:
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
		# add in all the balls we gained on our travels
		while(len(get_tree().get_nodes_in_group("balls")) < GameManager.num_of_balls):
			var new_ball := ball_template.instance()
			get_tree().get_root().add_child(new_ball)
			new_ball.position = self.position
			# all of these are grounded by default
			grounded_balls.append(new_ball)
	
	else:
		# set all other ball positiosn that touch the ground to be the position of the "lead ball"
		ball.position = lead_ball.position
	
	grounded_balls.append(ball)
	#print("Grounded Balls :" + str(len(grounded_balls)) + " Num of Balls :" + str(GameManager.num_of_balls))
	
	if len(grounded_balls) == GameManager.num_of_balls:
		GameManager.emit_signal("all_balls_grounded")
