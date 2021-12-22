extends Node

signal score_changed(new_score)

const starting_score_gain_per_tick = 10
var score_gain_per_tick = starting_score_gain_per_tick

var score: float
var high_score: float


func _ready() -> void:
	set_physics_process(false)
	connect("score_changed", SignalBus, "_on_score_changed")
	SignalBus.connect("game_start", self, "_on_game_start")
	SignalBus.connect("game_restart", self, "_on_game_restart")


func _physics_process(delta: float) -> void:
	set_score(score + score_gain_per_tick * delta)
	score_gain_per_tick += 3 * delta / score_gain_per_tick


func set_score(new_score: float) -> void:
	if new_score > high_score:
		high_score = new_score
	score = new_score
	emit_signal("score_changed", new_score)


func _on_player_die() -> void:
	set_physics_process(false)


func reset_score() -> void:
	score_gain_per_tick = starting_score_gain_per_tick
	set_score(0)


func _on_game_start() -> void:
	reset_score()
	set_physics_process(true)


func _on_game_restart() -> void:
	_on_game_start()
