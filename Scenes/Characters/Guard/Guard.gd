extends KinematicBody2D

export var MOVEMENT_SPEED = 100

var velocity = Vector2.ZERO
var current_map = null
var path = []

onready var WEAPON = $Blaster

func agressive_ai():
	print("agressive")
	
	
func _ready():
	current_map = owner.get_node("Map")
	if WEAPON.AI_TYPE == "A": agressive_ai()
