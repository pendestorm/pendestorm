extends Node2D

onready var timer = $GameEndTimer
onready var time_left_text = $CanvasLayer/TimeLeftLabel
onready var game_over_label = $CanvasLayer/GameOverLabel
onready var victory_label = $CanvasLayer/VictoryLabel
export var saved_to_win = 1

func _ready():
	SharedVariables.scene = self

func _process(_delta):
	time_left_text.text = "%d"%timer.time_left
	var count_saved = 0
	for nenito in get_tree().get_nodes_in_group("nenitos"):
		if nenito.saved:
			count_saved = count_saved +1
	if count_saved >= saved_to_win:
		win()
		
	
func add_nenito_to_game(nenito):
	$Walls.add_child(nenito)


func _on_GameEndTimer_timeout():
	game_over_label.show()
	$GameOverPlayer.play()
	get_tree().paused = true
	yield(get_tree().create_timer(24),"timeout")
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func win():
	victory_label.show()
	$VictoryPlayer.play()
	get_tree().paused = true
	yield(get_tree().create_timer(24),"timeout")
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
