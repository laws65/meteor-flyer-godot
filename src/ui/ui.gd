extends CanvasLayer


func _ready() -> void:
	SignalBus.connect("score_changed", self, "_on_score_changed")
	SignalBus.connect("game_start", self, "_on_game_start")
	SignalBus.connect("game_restart", self, "_on_game_restart")
	SignalBus.connect("player_die", self, "_on_player_die")


func _on_score_changed(score: float) -> void:
	$Control/ScoreCounter.text = str(int(score))


func _on_game_start() -> void:
	$AnimationPlayer.play("start_game")


func _on_game_restart() -> void:
	$AnimationPlayer.play("restart_game")


func _on_player_die() -> void:
	$Control/TitleText.text = "You died"
	$Control/ScoreText.text = "You had a score of %s" % int(Score.score) 
	$Control/ExplanationText.text = "Press any key to play again"
	$AnimationPlayer.play("player_die")
