extends Area2D


var velocity: Vector2

export var speed := 200
export var speed_variability := 50

export var rot := 120
export var rot_variability := 100

export var speed_increase_with_score := 0.0


func _on_ShieldPowerup_body_entered(player: Player) -> void:
	var new_shield_level = player.shield_level + 1
	if new_shield_level <= 3:
		player.set_shield_level(new_shield_level)
		queue_free()
