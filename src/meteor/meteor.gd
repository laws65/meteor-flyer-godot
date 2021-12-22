extends KinematicBody2D
class_name Meteor


var files = {
	big=["res://assets/PNG/Meteors/meteorBrown_big1.png",
		"res://assets/PNG/Meteors/meteorBrown_big2.png",
		"res://assets/PNG/Meteors/meteorBrown_big3.png",
		"res://assets/PNG/Meteors/meteorBrown_big4.png"],
	med=["res://assets/PNG/Meteors/meteorBrown_med1.png",
		"res://assets/PNG/Meteors/meteorBrown_med3.png"],
	small=["res://assets/PNG/Meteors/meteorBrown_small1.png",
		"res://assets/PNG/Meteors/meteorBrown_small2.png"],
	#tiny=["res://assets/PNG/Meteors/meteorBrown_tiny1.png",
	#	"res://assets/PNG/Meteors/meteorBrown_tiny2.png"],
}

var sizes = {
	big=39,
	med=17,
	small=11,
	#tiny=5
}

var size: String
var velocity: Vector2

export var speed := 200
export var speed_variability := 50

export var rot := 120
export var rot_variability := 100

export var speed_increase_with_score := 0.2


func _ready() -> void:
	var new_size = sizes.keys()[randi() % sizes.keys().size()]
	_set_size(new_size)


func get_shot() -> void:
	if size == "small":
		queue_free()
		return
	
	var new_index = sizes.keys().find(size) + 1
	var new_size = sizes.keys()[new_index]
	
	_set_size(new_size)


func _set_size(new_size: String) -> void:
	size = new_size
	
	var sprites = files[size]
	$Sprite.texture = load(sprites[randi() % sprites.size()])
	$CollisionShape2D.shape.radius = sizes[size]
