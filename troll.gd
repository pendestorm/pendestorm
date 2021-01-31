extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/second.
export var nenitos = []
export(Array,String) var objects_in_hand
onready var object_detector = $ObjectDetector
onready var sprite = $Sprite
onready var light2d = $Light2D
onready var tween : Tween = $Tween
onready var anim_player = $AnimationPlayer
onready var pasos_player = $PasosPlayer

signal follow_me
signal stop

var last_time_frame := 0
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

export(Array,AudioStream) var pasos_bosque
export(Array,AudioStream) var pasos_agua

func _ready():
	SharedVariables.player = self
	#Esto es una prueba
	for nenito in get_tree().get_nodes_in_group("nenitos"):
		add_nenito(nenito)


func _physics_process(_delta):
	z_index = int(position.y)
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(motion)

	if OS.get_ticks_msec() > last_time_frame + 100:
		if motion != Vector2(0,0):
			emit_signal("follow_me", self.global_position)
		else:
			emit_signal("stop")
		last_time_frame = OS.get_ticks_msec()
func add_nenito(nenito):
	nenitos.append(nenito)
	nenito.line_pos = nenitos.size()
	add_collision_exception_with(nenito)
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
			"linterna": light2d.show()
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
	var current_rotation = light2d.rotation_degrees
	if down and right:
		#sprite.frame_coords = Vector2(6,0)
		anim_player.play("down_walk")
		var degrees = select_between_degrees(light2d.rotation_degrees,40)
		tween.interpolate_property(light2d,"rotation_degrees",current_rotation,degrees,0.1)
	elif down and left:
		#sprite.frame_coords = Vector2(0,0)
		anim_player.play("down_walk")
		var degrees = select_between_degrees(light2d.rotation_degrees,140)
		tween.interpolate_property(light2d,"rotation_degrees",current_rotation,degrees,0.1)
	elif up and right:
		#sprite.frame_coords = Vector2(4,0)
		anim_player.play("up_right_walk")
		var degrees = select_between_degrees(light2d.rotation_degrees,-40)
		tween.interpolate_property(light2d,"rotation_degrees",current_rotation,degrees,0.1)
	elif up and left:
		#sprite.frame_coords = Vector2(2,0)
		anim_player.play("up_left_walk")
		var degrees = select_between_degrees(light2d.rotation_degrees,-130)
		tween.interpolate_property(light2d,"rotation_degrees",current_rotation,degrees,0.1)
	elif left:
		#sprite.frame_coords = Vector2(1,0)
		anim_player.play("left_walk")
		var degrees = select_between_degrees(light2d.rotation_degrees,180)
		tween.interpolate_property(light2d,"rotation_degrees",current_rotation,degrees,0.1)
	elif up:
		#sprite.frame_coords = Vector2(3,0)
		anim_player.play("up_walk")
		var degrees = select_between_degrees(light2d.rotation_degrees,-90)
		tween.interpolate_property(light2d,"rotation_degrees",current_rotation,degrees,0.1)
	elif right:
		#sprite.frame_coords = Vector2(5,0)
		anim_player.play("right_walk")
		var degrees = select_between_degrees(light2d.rotation_degrees,0)
		tween.interpolate_property(light2d,"rotation_degrees",current_rotation,degrees,0.1)
	elif down:
		#sprite.frame_coords = Vector2(7,0)
		anim_player.play("down_walk")
		var degrees = select_between_degrees(light2d.rotation_degrees,90)
		tween.interpolate_property(light2d,"rotation_degrees",current_rotation,degrees,0.1)
	if not right and not left and not up and not down:
		anim_player.stop()
		match sprite.frame:
			0,1,2,3:
				sprite.frame = 0
			4,5,6,7:
				sprite.frame = 4
			8,9,10,11:
				sprite.frame = 8
			12,13,14,15:
				sprite.frame = 12
	tween.start()
		
func save_nenitos():
	for n in nenitos:
		disconnect("follow_me", n, "_on_Troll_follow_me")
		disconnect("stop", n, "_on_Troll_stop")
		n.saved = true
	
func select_between_degrees(current,next):
	if current == next: return next
	var contrary_next = 360+next if next < 0 else next-360
	if abs(current-next) < abs(current-contrary_next):
		return next
	else:
		return contrary_next
		
func choose_walk_sound():
	var wtm = get_parent().world_to_map(position)
	var cell_id = get_parent().get_parent().get_node("Floor").get_cellv(wtm)
	if cell_id == 1:
		pasos_player.stream = pasos_agua[rng.randi_range(0,7)]
		pasos_player.play()
	else:
		pasos_player.stream = pasos_bosque[rng.randi_range(0,6)]
		pasos_player.play()
