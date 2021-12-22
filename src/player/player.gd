extends KinematicBody2D
class_name Player


signal on_die()

export var laser_scene: PackedScene

const position_weight := 0.1

var score_gain_per_tick = 10
var shield_level := 0
var shoot_speed = 0.2
var can_shoot = true


func _ready() -> void:
	connect("on_die", SignalBus, "_on_player_die")
	connect("on_die", Score, "_on_player_die")
	connect("on_die", self, "_on_die")
	SignalBus.connect("game_restart", self, "_on_game_restart")


func _physics_process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var velocity = ((mouse_pos - position) * position_weight) / delta
	
	var mouse_local = mouse_pos - get_global_position()
	rotation = atan2(mouse_local.y, mouse_local.x)
	
	move_and_slide(velocity)
	var collision := get_last_slide_collision()
	if collision != null and $AnimationPlayer.current_animation != "hurt":
		$AnimationPlayer.stop()
		$AnimationPlayer.play("hurt")
		set_shield_level(shield_level-1)
	
	if Input.is_action_pressed("shoot"):
		shoot()



func _on_ShootCooldown_timeout() -> void:
	can_shoot = true


func shoot() -> void:
	if not can_shoot:
		return
	
	can_shoot = false
	AudioManager.play("res://assets/Bonus/sfx_laser2.ogg")
	var laser_instance = laser_scene.instance()
	owner.add_child(laser_instance)
	laser_instance.rotation = rotation
	laser_instance.global_position = $LaserOrigin.global_position
	laser_instance.velocity = Vector2(cos(rotation), sin(rotation)) * laser_instance.speed
	$ShootCooldown.start(shoot_speed)


func set_shield_level(new_shield_level: int) -> void:
	new_shield_level = clamp(new_shield_level, 0.0, 3.0)
	
	if shield_level > new_shield_level:
		if new_shield_level == 0:
			AudioManager.play("res://assets/Bonus/sfx_lose.ogg")
		else:
			AudioManager.play("res://assets/Bonus/sfx_shieldDown.ogg")
	elif shield_level < new_shield_level:
		AudioManager.play("res://assets/Bonus/sfx_shieldUp.ogg")
	elif shield_level == 0:
		emit_signal("on_die")
	
	shield_level = new_shield_level

	var shield_texture = null
	if shield_level > 0:
		shield_texture = load("res://assets/PNG/Effects/shield%s.png" % shield_level)
	$Shield.set_texture(shield_texture)


func _on_die() -> void:
	AudioManager.play("res://assets/Bonus/sfx_lose.ogg")
	set_physics_process(false)


func _on_game_restart() -> void:
	set_physics_process(true)
	_reset()


func _reset() -> void:
	var window_size = Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height"))
	position = window_size / 2
	
	$AnimationPlayer.play("RESET")
