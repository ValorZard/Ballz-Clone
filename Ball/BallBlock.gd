extends Area2D

class_name BallBlock

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const DEBUG = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BallBlock_body_entered(body):
	if body is Ball:
		GameManager.num_of_balls += 1
		self.queue_free()
	if body is Ground:
		self.queue_free()
		if DEBUG:
			print("Deleting ball block since it touched the ground")
