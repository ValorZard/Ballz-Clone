extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAX_SPEED = 400

# the leader ball of the group
var lead_ball : Ball

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
	for ball in get_tree().get_nodes_in_group("balls"):
		if ball is Ball:
			ball.speed = MAX_SPEED
			ball.direction = mouse_direction
			ball.velocity = ball.speed * ball.direction
			ball.current_state = GameManager.BALL_STATE.MOVING
	GameManager.emit_signal("ball_shoot")

func  _on_ball_hit_ground(new_position : Vector2):
	# show label text again
	$Label.visible = true
	self.position = new_position
	print(new_position)
