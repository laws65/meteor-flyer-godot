extends Area2D
class_name Point

onready var type = points.keys()[randi() % points.keys().size()]

var points = {
	gold=100,
	silver=50,
	bronze=15
}

var velocity: Vector2

export var speed := 200
export var speed_variability := 50

export var rot := 120
export var rot_variability := 100

export var speed_increase_with_score := 0


func _ready() -> void:
	$Sprite.texture = load("res://assets/PNG/Power-ups/star_%s.png" % type)


func _on_Points_body_entered(_player: Player) -> void:
	AudioManager.play("res://assets/Bonus/sfx_shieldUp.ogg")
	var new_score = Score.score + points[type]
	Score.set_score(new_score)
	queue_free()
