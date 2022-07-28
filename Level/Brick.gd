extends KinematicBody2D

class_name Brick

var row : int = 0
var health : int = 1

var empty_velocity : Vector2 = Vector2(0,0)

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

func _physics_process(delta : float):
	var collision_info = move_and_collide(empty_velocity * delta)
	
	if collision_info:
		var body = collision_info.collider
		
		if body is Ground:
			self.queue_free()
