extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.connect("button_down", self, "start_game")

func start_game():
	get_tree().change_scene("res://Level/Root.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	pass
