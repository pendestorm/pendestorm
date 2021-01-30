extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/second.
export var nenitos = []
export(Array,String) var objects_in_hand
onready var object_detector = $ObjectDetector
onready var sprite = $Sprite
onready var light2d = $Light2D

signal follow_me
signal stop

func _ready():
	SharedVariables.player = self
	#Esto es una prueba
	add_nenito(get_parent().get_node("Nenito"))
	add_nenito(get_parent().get_node("Nenito2"))


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

func _process(_delta):
	#$Light2D.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("action"):
		var wtm = get_parent().world_to_map(position)
		print(wtm," ",get_parent().get_parent().get_node("Floor").get_cellv(wtm))
		var objects = object_detector.get_overlapping_areas()
		if objects.size() < 1: return
		var nearest_object = objects[0]
		var object_keyword_identifier = nearest_object.keyword_identifier
		objects_in_hand.append(object_keyword_identifier)
		match object_keyword_identifier:
			"key": modulate = Color.aqua
		nearest_object.queue_free()
		
	#Sprite movement
	var down
	var up
	var left
	var right
	if Input.get_action_strength("move_down") > Input.get_action_strength("move_up"):
		down = true
	elif Input.get_action_strength("move_down") < Input.get_action_strength("move_up"):
		up = true
	if Input.get_action_strength("move_left") > Input.get_action_strength("move_right"):
		left = true
	elif Input.get_action_strength("move_left") < Input.get_action_strength("move_right"):
		right = true
	if down and right:
		sprite.frame_coords = Vector2(6,0)
		light2d.rotation_degrees = 40
	elif down and left:
		sprite.frame_coords = Vector2(0,0)
		light2d.rotation_degrees = 140
	elif up and right:
		sprite.frame_coords = Vector2(4,0)
		light2d.rotation_degrees = 320
	elif up and left:
		sprite.frame_coords = Vector2(2,0)
		light2d.rotation_degrees = 230
	elif left:
		sprite.frame_coords = Vector2(1,0)
		light2d.rotation_degrees = 180
	elif up:
		sprite.frame_coords = Vector2(3,0)
		light2d.rotation_degrees = 270
	elif right:
		sprite.frame_coords = Vector2(5,0)
		light2d.rotation_degrees = 0
	elif down:
		sprite.frame_coords = Vector2(7,0)
		light2d.rotation_degrees = 90
		
	
