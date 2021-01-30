extends Area2D

var player_inside_range := false
var showed_negation_label := false
export var object_keyword_neccesary := ""

func _on_RescueNenePlace_body_entered(body):
	$ShowIcon.play("show_icon")
	player_inside_range = true

func _on_RescueNenePlace_body_exited(body):
	$ShowIcon.play_backwards("show_icon")
	player_inside_range = false
	if showed_negation_label:
		$ShowNegation.play_backwards("show_negation_label")

func _process(_delta):
	if player_inside_range and Input.is_action_just_pressed("action"):
		print("you touched me!")
		for object in SharedVariables.player.objects_in_hand:
			if object == object_keyword_neccesary:
				print("you passed")
				return
		$ShowNegation.play("show_negation_label")
		showed_negation_label = true




