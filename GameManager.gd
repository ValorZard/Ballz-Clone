extends Node

const GROUND_POSITION = 500 # in x coordinates
enum BALL_STATE {MOVING, STOPPED}

var num_of_balls : int = 1

signal hit_ground(position)
signal ball_shoot()
