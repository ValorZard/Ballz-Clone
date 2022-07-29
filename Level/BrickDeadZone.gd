extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", self, "area_entered")
	self.connect("body_entered", self, "body_entered")

# delete ball blocks
func area_entered(area):
	if area is BallBlock:
		area.queue_free()

# delete brick blocks
func body_entered(body):
	if body is Brick:
		body.queue_free()
		GameManager.emit_signal("brick_hit_ground")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
