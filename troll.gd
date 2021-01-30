extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/second.
export var nenitos = []
signal follow_me
signal stop

func _ready():
	add_nenito(get_parent().get_parent().get_node("Nenito"))
	add_nenito(get_parent().get_parent().get_node("Nenito2"))
func _physics_process(_delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(motion)
	if motion != Vector2(0,0):
		emit_signal("follow_me", self.global_position)
	else:
		emit_signal("stop")
		
func add_nenito(nenito):
	nenitos.append(nenito)
	nenito.line_pos = nenitos.size()
	connect("follow_me", nenito, "_on_Troll_follow_me")
	connect("stop", nenito, "_on_Troll_stop")
	
func lose_nenito(object):
	nenitos.pop_back()
