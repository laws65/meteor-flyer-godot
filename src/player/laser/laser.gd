extends KinematicBody2D


var velocity: Vector2
var speed: int = 3000


func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)
	
	var collision := get_last_slide_collision()
	if collision != null:
		collision.collider.get_shot()
		queue_free()


func _on_CullTimer_timeout() -> void:
	queue_free()
