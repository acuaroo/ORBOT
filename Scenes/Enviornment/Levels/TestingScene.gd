extends Node2D

func _ready():
	var _s = $Player.connect("orb_shot", $UI/CanvasLayer/OrbFeed, "new_rotation")
