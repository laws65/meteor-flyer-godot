extends Node


signal player_die()
signal game_start()
signal score_changed(score)
signal game_restart()


func _on_score_changed(score: float) -> void:
	emit_signal("score_changed", score)


func _on_player_die() -> void:
	emit_signal("player_die")


func _on_game_start() -> void:
	emit_signal("game_start")


func _on_game_restart() -> void:
	emit_signal("game_restart")
