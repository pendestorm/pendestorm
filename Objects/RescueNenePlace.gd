extends Area2D

var player_inside_range := false
var showed_negation_label := false
export var object_keyword_neccesary := ""
export(PackedScene) var nene
var nene_rescued := false

func _on_RescueNenePlace_body_entered(body):
	$ShowIcon.play("show_icon")
	player_inside_range = true

func _on_RescueNenePlace_body_exited(body):
	$ShowIcon.play_backwards("show_icon")
	player_inside_range = false
	if showed_negation_label:
		$ShowNegation.play_backwards("show_negation_label")

func _process(_delta):
	if not nene_rescued and player_inside_range and Input.is_action_just_pressed("action"):
		print("you touched me!")
		for object in SharedVariables.player.objects_in_hand:
			if object == object_keyword_neccesary:
				print("you passed")
				var new_nene = nene.instance()
				SharedVariables.scene.add_nenito_to_game(new_nene)
				new_nene.position = SharedVariables.player.position + Vector2(10,10)
				SharedVariables.player.add_nenito(new_nene)
				nene_rescued = true
				return
		$ShowNegation.play("show_negation_label")
		showed_negation_label = true




