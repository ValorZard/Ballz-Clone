extends Node

const GROUND_POSITION = 450 # in x coordinates
enum BALL_STATE {MOVING, STOPPED}

var num_of_balls : int = 1
var score : int = 0

signal hit_ground(ball)
signal ball_shoot()
signal all_balls_grounded()
signal brick_hit_ground()
