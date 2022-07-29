extends KinematicBody2D

class_name Brick

var row : int = 0
var health : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health(health)

func set_health(h : int):
	health = h
	$Label.text = str(health)

func on_hit():
	health -= 1
	$Label.text = str(health)
	if health <= 0:
		die()

func die():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(self.position.y > GameManager.GROUND_POSITION):
		self.queue_free()
		GameManager.emit_signal("brick_hit_ground")
