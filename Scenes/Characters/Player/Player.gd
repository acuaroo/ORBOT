extends KinematicBody2D

signal orb_shot

export var MOVEMENT_SPEED = 4000
export var DEBOUNCE_TIME = 1
export var SET = 4000
export var ALIVE = true

const orb_path = preload("res://Scenes/Weapons/Player/Orb.tscn")

var move_vec = Vector2()
var db = false
var orb = null

onready var animated = $AnimatedSprite
onready var orb_spawn = $OrbLauncher/OrbSpawn
onready var raycast  = $OrbLauncher/RayCast
onready var orb_launcher = $OrbLauncher

func _ready():
	yield(get_tree(), "idle_frame")
	orb_launcher.play("idle")
		
		
func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	$Camera.offset_h = (mouse_pos.x - global_position.x) / (1920.0 / 2.3)
	$Camera.offset_v = (mouse_pos.y - global_position.y) / (1920.0 / 2.3)
	look_at(mouse_pos)
	
	
	if Input.is_action_just_pressed("mb1_click"):
		shoot()
	
	verify_movement()
	
	if global_position.distance_to(mouse_pos) > 1: 
		var _m = move_and_slide((move_vec * MOVEMENT_SPEED * delta).rotated(rotation))
	else:
		animated.play("idle")

func verify_movement():
	if Input.is_action_pressed("ui_up"):
		move_vec.x = 1 
	else:
		move_vec.x = 0
	
	if move_vec == Vector2():
		animated.play("idle")
	else:
		animated.play("walk")
	
func place_orb():
	var orb_list = get_parent().get_node("UI/CanvasLayer/OrbFeed").orb_list
	orb = orb_path.instance()
	get_parent().add_child(orb)
	
	emit_signal("orb_shot")
	
	orb.get_child(0).animation = orb_list["C"].name.to_lower()+"_spin"
	
	orb.position = orb_spawn.global_position
	orb.look_at(orb_launcher.global_position)
	orb.global_rotation_degrees += 270
	orb.type = orb_list["C"]
	orb.velocity = -(orb_launcher.global_position - orb.position)

func animate_orb_launcher():
	orb_launcher.get_node("Tween").interpolate_property(orb_launcher, "position", Vector2(6, 5), Vector2(1, 5), 0.12, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	orb_launcher.get_node("Tween").start()
	
	yield(orb_launcher.get_node("Tween"), "tween_completed")
	
	orb_launcher.get_node("Tween").interpolate_property(orb_launcher, "position", Vector2(1, 5), Vector2(6, 5), 0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT_IN)
	orb_launcher.get_node("Tween").start()
	
func shoot():
	if db == false and not raycast.is_colliding():
		db = true
		
		animate_orb_launcher()
		place_orb()
		
		yield(orb_launcher.get_node("Tween"), "tween_completed")
		yield(get_tree().create_timer(DEBOUNCE_TIME), "timeout")
		db = false
	
func _on_SlimeBox_area_entered(area):
	if "SlimePlace" in area.get_parent().name:
		MOVEMENT_SPEED /= area.get_parent().SLOW_DIV

func _on_SlimeBox_area_exited(area):
	if "SlimePlace" in area.get_parent().name:
		MOVEMENT_SPEED *= area.get_parent().SLOW_DIV
