extends KinematicBody2D

var do_not_follow
var line_pos

func _ready():
	pass # Replace with function body.


func _on_Troll_follow_me(position):
	$Tween.interpolate_property(self, "position", self.position, (position*(1-line_pos*0.05)),1, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start()
	pass # Replace with function body.


func _on_Troll_stop():
	pass # Replace with function body.
