extends TextureRect

const valid_orbs = [
	"TELEPORT",
	"RICOCHET",
	"SLIME"
]

var orb_list = {
	"C": "null",
	"1": "null",
	"2": "null",
	"3": "null"
}

var thread

onready var current = $HBoxContainer/Current
onready var slot1 = $HBoxContainer/Slot1
onready var slot2 = $HBoxContainer/Slot2
onready var slot3 = $HBoxContainer/Slot3

func _ready():
	randomize()
	
	for key in orb_list:
		var b = randi()
		var rand_orb = valid_orbs[b % valid_orbs.size()]
		asign(rand_orb, key)
		
	set_textures()
	
	thread = Thread.new()
	var _t = thread.start(self, "buddy")

func asign(rand_orb, key):
	if rand_orb == "TELEPORT": orb_list[key] = $TELEPORT
	if rand_orb == "RICOCHET": orb_list[key] = $RICOCHET
	if rand_orb == "SLIME": orb_list[key] = $SLIME
	
func last_random():
	orb_list["C"] = orb_list["1"] 
	orb_list["1"] = orb_list["2"] 
	orb_list["2"] = orb_list["3"]
	
	var b = randi()
	var rand_orb = valid_orbs[b % valid_orbs.size()]
	
	asign(rand_orb, "3")

func set_textures():
	current.texture = orb_list["C"].texture
	slot1.texture = orb_list["1"].texture
	slot2.texture = orb_list["2"].texture
	slot3.texture = orb_list["3"].texture

func new_rotation():
	current.get_child(0).interpolate_property(current, "rect_position", Vector2(0, 0), Vector2(0, 20), 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	current.get_child(0).start()
	
	yield(current.get_child(0), "tween_completed")
	
	slot1.get_child(0).interpolate_property(slot1, "rect_position", Vector2(16, 0), Vector2(0, 0), 0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	slot1.get_child(0).start()
	
	slot2.get_child(0).interpolate_property(slot2, "rect_position", Vector2(32, 0), Vector2(16, 0), 0.3, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	slot2.get_child(0).start()
	
	slot3.get_child(0).interpolate_property(slot3, "rect_position", Vector2(48, 0), Vector2(32, 0), 0.3, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	slot3.get_child(0).start()
	
	yield(slot1.get_child(0), "tween_completed")
	last_random()
	
	current.texture = slot1.texture
	slot1.texture = slot2.texture
	slot2.texture = slot3.texture
	slot3.texture = orb_list["3"].texture
	
	current.rect_position = Vector2(0, 0)
	slot1.rect_position = Vector2(16, 0)
	slot2.rect_position = Vector2(32, 0)
	slot3.rect_position = Vector2(48, 16)
	
	slot3.get_child(0).interpolate_property(slot3, "rect_position", Vector2(48, 16), Vector2(48, 0), 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
	slot3.get_child(0).start()

func buddy():
	while true:
		yield(get_tree().create_timer(rand_range(4, 10)), "timeout")
		$Buddy.frame = 0
		$Buddy.play("blink")

func _exit_tree():
	thread.wait_to_finish()
