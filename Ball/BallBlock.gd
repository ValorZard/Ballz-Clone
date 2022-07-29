extends Area2D

class_name BallBlock

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(self.position.y > GameManager.GROUND_POSITION):
		self.queue_free()


func _on_BallBlock_body_entered(body):
	if body is Ball:
		GameManager.num_of_balls += 1
		self.queue_free()
