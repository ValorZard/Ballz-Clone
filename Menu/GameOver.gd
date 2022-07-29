extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/RestartButton.connect("button_down", self, "restart_game")
	$VBoxContainer/TitleButton.connect("button_down", self, "back_to_title")

func set_score(new_score : int):
	score = new_score
	$ScoreLabel.text = "Score: " + str(score)

func restart_game():
	# Remove the current level
	self.queue_free()
	get_tree().change_scene("res://Level/Root.tscn")

func back_to_title():
	# Remove the current level
	self.queue_free()
	get_tree().change_scene("res://Menu/TitleScreen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_score(GameManager.score)
