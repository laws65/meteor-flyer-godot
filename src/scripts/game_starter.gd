extends Node


signal game_start
signal game_restart

var playing := false
var started := false


func _ready() -> void:
	connect("game_start", SignalBus, "_on_game_start")
	connect("game_restart", SignalBus, "_on_game_restart")
	SignalBus.connect("player_die", self, "_on_player_die")
	yield(get_tree().get_root(), "ready")


func _input(event: InputEvent) -> void:
	if playing:
		return
	if event is InputEventMouseMotion:
		return
	if not ((event is InputEventKey and not event.is_echo()) or event is InputEventMouseButton):
		return
	if not event.is_pressed():
		return
	
	if started:
		emit_signal("game_restart")
	else:
		emit_signal("game_start")
		started = true
	
	playing = true


func _on_player_die() -> void:
	playing = false
