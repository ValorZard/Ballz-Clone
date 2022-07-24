extends KinematicBody2D

var anchor_point_y = 10

# Movement
const SPEEDUP = 2
const MAX_SPEED = 250

export var speed : float = 0
var direction := Vector2()
var velocity := Vector2()

enum BALL_STATE {MOVING, STOPPED}

var current_state = BALL_STATE.STOPPED

signal got_brick
signal hit_ground
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if current_state == BALL_STATE.STOPPED:
		if event.is_action_pressed("shoot"):
			var mouse_direction : Vector2 = get_global_mouse_position() - self.position
			mouse_direction = mouse_direction.normalized()
			_on_ball_shot(mouse_direction)

# handle display stuff
func _process(delta : float):
	if current_state == BALL_STATE.STOPPED:
		$DirectionLine.clear_points()
		# needs things in local position
		$DirectionLine.add_point($DirectionLine.to_local(self.position))
		$DirectionLine.add_point($DirectionLine.to_local(get_global_mouse_position()))
	else:
		$DirectionLine.clear_points()

func _physics_process(delta : float):

	if current_state == BALL_STATE.MOVING:
		var collision_info = move_and_collide(velocity * delta)

		if collision_info:
			var body = collision_info.collider

			if body is Brick:
				body.queue_free()
				velocity = velocity.bounce(collision_info.normal)
			elif body is Ground:
				current_state = BALL_STATE.STOPPED
				emit_signal("hit_ground")
			else:
				velocity = velocity.bounce(collision_info.normal)

func _on_ball_shot(mouse_direction : Vector2):
	speed = MAX_SPEED
	direction = mouse_direction
	velocity = speed * direction
	current_state = BALL_STATE.MOVING
