extends KinematicBody2D

export var MOVEMENT_SPEED = 100
export var BOUNCE = 0.6
export var SET = 100

const teleport_particles = preload("res://Scenes/Weapons/Player/Orbs/RicochetOrbExplosion.tscn")
const ricochet_particles = preload("res://Scenes/Weapons/Player/Orbs/RicochetOrbExplosion.tscn")
const slime_particles = preload("res://Scenes/Weapons/Player/Orbs/SlimeOrbExplosion.tscn")
const slime_place = preload("res://Scenes/Weapons/Player/OrbAssets/SlimePlace.tscn")

var velocity = Vector2(0, 0)
var ricochet_set = 0
var type = null
var db = false

func _physics_process(delta):
	var collission_info = move_and_collide(velocity.normalized() * delta * MOVEMENT_SPEED)
	
	if collission_info and db == false:
		db = true
		var part = null
		
		if type.name == "TELEPORT":
			part = teleport_particles.instance()
			teleport_collission()
			
		elif type.name == "RICOCHET":
			part = ricochet_particles.instance()
			ricochet_collission(collission_info.normal, collission_info.collider)
			db = false
		
		elif type.name == "SLIME":
			part = slime_particles.instance()
			slime_collission()
			
		get_parent().add_child(part)
		part.global_position = global_position
		part.emitting = true

func reflect(norm, vel):
	return vel - (2*(vel * norm))*norm
	
func teleport_collission():
	var player = get_parent().get_node("Player")
	player.global_position = global_position
	queue_free()

func slime_collission():
	var slime = slime_place.instance()
	get_parent().add_child(slime)
	slime.global_position = global_position
	queue_free()
	
func ricochet_collission(normal, collider):
	ricochet_set += 1
	
	if ricochet_set == 2:
		teleport_collission()
	else:
		velocity = reflect(normal, velocity) * BOUNCE
		look_at(collider.global_position)
		global_rotation_degrees += 270

func _on_SlimeBox_area_exited(area):
	if "SlimePlace" in area.get_parent().name:
		MOVEMENT_SPEED *= area.get_parent().SLOW_DIV

func _on_SlimeBox_area_entered(area):
	if "SlimePlace" in area.get_parent().name:
		MOVEMENT_SPEED /= area.get_parent().SLOW_DIV
