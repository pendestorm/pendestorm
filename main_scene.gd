extends Node2D

onready var timer = $GameEndTimer
onready var time_left_text = $CanvasLayer/TimeLeftLabel
onready var game_over_label = $CanvasLayer/GameOverLabel

func _process(_delta):
	time_left_text.text = "%d"%timer.time_left
	


func _on_GameEndTimer_timeout():
	game_over_label.show()
	$GameOverPlayer.play()
	get_tree().paused = true
	yield(get_tree().create_timer(24),"timeout")
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
