extends YSort
class_name EntitySpawner


onready var window_size = Vector2(
	ProjectSettings.get("display/window/size/width"),
	ProjectSettings.get("display/window/size/height"))

var _timer: Timer = Timer.new()

export var entity_scene: PackedScene
export var spawn_offset := 60
export(float, 0.1, 50) var spawn_rate = 0.1
export(float, 0.0, 50) var spawn_rate_randomness = 0.0
export(float, 0.0, 1.0) var spawn_rate_score_modifier = 0.0


func _ready() -> void:
	_timer.paused = true
	SignalBus.connect("player_die", self, "_on_player_die")
	SignalBus.connect("game_start", self, "_on_game_start")
	SignalBus.connect("game_restart", self, "_on_game_restart")
	_setup_timer()


func _setup_timer() -> void:
	_timer.set_wait_time(spawn_rate)
	_timer.set_autostart(true)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(_timer)


func _on_Timer_timeout() -> void:
	_spawn_entity()
	_cull_entities()

	var level = Score.score/1250
	var wait_time = spawn_rate - level * spawn_rate_score_modifier
	wait_time *= rand_range(1-spawn_rate_randomness, 1+spawn_rate_randomness)
	set_spawn_rate(max(wait_time, 0.1))


func _spawn_entity() -> void:
	var entity = entity_scene.instance()
	add_child(entity)
	
	if randi() % 2:
		entity.position.x = rand_range(0, window_size.x)
		if randi() % 2: # go down
			entity.position.y = -spawn_offset
			entity.velocity.y = entity.speed
		else: # go up
			entity.position.y = window_size.y + spawn_offset
			entity.velocity.y = -entity.speed
	else:
		entity.position.y = rand_range(0, window_size.y)
		if randi() % 2: # go right
			entity.position.x = -spawn_offset
			entity.velocity.x = entity.speed
		else: # go left
			entity.position.x = window_size.x + spawn_offset
			entity.velocity.x = -entity.speed
	
	var v = entity.speed_variability
	entity.velocity += Vector2(rand_range(-v, v), rand_range(-v, v))
	entity.velocity *= 1 + ((Score.score/3000)) * entity.speed_increase_with_score


func _cull_entities() -> void:
	for child in get_children():
		if child is Timer:
			continue
		
		var voffset = Vector2(spawn_offset, spawn_offset)
		var screen_rect = Rect2(Vector2.ZERO - voffset*10, window_size + voffset*10)
		if not screen_rect.has_point(child.get_position()):
			child.queue_free()


func set_spawn_rate(new_spawn_rate: float) -> void:
	_timer.set_wait_time(new_spawn_rate)


func _on_player_die() -> void:
	_timer.paused = true


func _on_game_start() -> void:
	_timer.paused = false
	


func _on_game_restart() -> void:
	_on_game_start()
	for child in get_children():
		if not child is Timer:
			child.queue_free()
