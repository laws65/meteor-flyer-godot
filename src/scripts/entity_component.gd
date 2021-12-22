extends Node
class_name EntityComponent


var rot := 0

func _ready() -> void:
	rot = owner.rot + rand_range(-owner.rot_variability, owner.rot_variability)
	SignalBus.connect("player_die", self, "_on_player_die")


func _process(delta: float) -> void:
	owner.rotation_degrees += rot * delta


func _physics_process(delta: float) -> void:
	if owner is Area2D:
		owner.position += owner.velocity * delta
	elif owner is KinematicBody2D:
		owner.move_and_slide(owner.velocity)


func _on_player_die() -> void:
	set_physics_process(false)
