extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/second.

onready var object_detector = $ObjectDetector

func _physics_process(_delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(motion)

func _process(_delta):
	if Input.is_action_just_pressed("action"):
		var objects = object_detector.get_overlapping_areas()
		var nearest_object = objects[0]
		var object_keyword_identifier = nearest_object.keyword_identifier
		match object_keyword_identifier:
			"key": modulate = Color.aqua
		nearest_object.queue_free()
