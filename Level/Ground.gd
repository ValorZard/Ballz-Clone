extends KinematicBody2D

class_name Ground
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var empty_velocity : Vector2 = Vector2(0,0) # dummy velocity to get collision info
const DEBUG = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta : float):
#	var collision_info = move_and_collide(empty_velocity)
#	if collision_info:
#		var body = collision_info.collider
#
#		if body is Brick:
#			body.queue_free()
#			if DEBUG:
#				print("Deleted block since its now offscreen")
	pass
