extends KinematicBody2D

class_name Ball

var anchor_point_y = 10

# Movement
const SPEEDUP = 2

export var speed : float = 0
var direction := Vector2()
var velocity := Vector2()

var current_state = GameManager.BALL_STATE.STOPPED

signal got_brick
signal hit_ground
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("balls")


func _physics_process(delta : float):

	if current_state == GameManager.BALL_STATE.MOVING:
		var collision_info = move_and_collide(velocity * delta)

		if collision_info:
			var body = collision_info.collider

			if body is Brick:
				body.on_hit()
				velocity = velocity.bounce(collision_info.normal)
			elif body is Ground:
				current_state = GameManager.BALL_STATE.STOPPED
				GameManager.emit_signal("hit_ground", self)
			else:
				velocity = velocity.bounce(collision_info.normal)
