extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAX_SPEED = 400
const TIME_BETWEEN_BALLS = 0.1
# the leader ball of the group
var lead_ball : Ball
var ball_template : PackedScene = preload("res://Ball/Ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("hit_ground", self, "_on_ball_hit_ground")
	lead_ball = get_tree().get_nodes_in_group("balls")[0]



func _input(event):
	if lead_ball.current_state == GameManager.BALL_STATE.STOPPED:
		if event.is_action_pressed("shoot"):
			var mouse_direction : Vector2 = get_global_mouse_position() - self.position
			mouse_direction = mouse_direction.normalized()
			_on_ball_shot(mouse_direction)
			# turn label off now that its moving
			$Label.visible = false

# handle display stuff
func _process(delta : float):
	if lead_ball.current_state == GameManager.BALL_STATE.STOPPED:
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
	# add in all the balls we gained on our travels
	while(len(get_tree().get_nodes_in_group("balls")) < GameManager.num_of_balls):
		var ball := ball_template.instance()
		get_tree().get_root().add_child(ball)
		ball.position = self.position
	
	
	for ball in get_tree().get_nodes_in_group("balls"):
		if ball is Ball:
			ball.speed = MAX_SPEED
			ball.direction = mouse_direction
			ball.velocity = ball.speed * ball.direction
			ball.current_state = GameManager.BALL_STATE.MOVING
		# give time to shoot out each ball
		yield(get_tree().create_timer(TIME_BETWEEN_BALLS), "timeout")
	GameManager.emit_signal("ball_shoot")

func  _on_ball_hit_ground(ball : Ball):
	# show label text again
	$Label.visible = true
	self.position = ball.position
	#print(new_position)
	
#	# spawn in new balls for the ones we deleted (oh god I should find a better way)
#	# this will be called every time a ball hits the ground, so this will automatically account for all the balls
#	var ball := ball_template.instance()
#	get_tree().get_root().add_child(ball)
#	ball.position = self.position
#
#	lead_ball = ball
