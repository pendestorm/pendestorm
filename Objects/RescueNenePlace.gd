extends Area2D

var player_inside_range := false
var showed_negation_label := false
export var object_keyword_neccesary := ""
export(NodePath) var nene_path
var nene
var nene_rescued := false
var parent

func _ready():
	if nene_path != "":
		nene = get_node(nene_path)
		parent = nene.get_parent()
		parent.remove_child(nene)

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
			if (object == object_keyword_neccesary and object_keyword_neccesary != "machete" and object_keyword_neccesary != "antorcha") or object_keyword_neccesary == "" :
				print("you passed")
				parent.add_child(nene)
				SharedVariables.scene.add_nenito_to_game(nene)
				nene.position = SharedVariables.player.position + Vector2(10,10)
				SharedVariables.player.add_nenito(nene)
				nene_rescued = true
				return
			elif (object == "machete" and object_keyword_neccesary == "machete") or (object == "antorcha" and object_keyword_neccesary == "antorcha"):
				var tileset = get_parent().get_parent().get_node("Walls") if object == "machete" else get_parent().get_node("Walls")
				var wtm = tileset.world_to_map(position)
				var cell_id = tileset.get_cellv(wtm)
				if (cell_id == 4 and object == "machete") or (cell_id == 17 and object == "antorcha"):
					tileset.set_cellv(wtm,-1)
					if object == "machete":
						$ObjectSound.play("machete")
					else:
						$ObjectSound.play("antorcha")
						parent.add_child(nene)
						SharedVariables.scene.add_nenito_to_game(nene)
						nene.position = SharedVariables.player.position + Vector2(10,10)
						SharedVariables.player.add_nenito(nene)
					nene_rescued = true
				return
		$ShowNegation.play("show_negation_label")
		showed_negation_label = true




