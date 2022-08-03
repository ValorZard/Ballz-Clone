extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var next_level_scene : PackedScene = preload("res://Level/Root.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "body_entered")

func body_entered(body):
	if body is Ball:
		get_tree().change_scene_to(next_level_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
