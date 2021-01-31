tool
extends KinematicBody2D

export var pilotin : Color = Color.white setget color_change
export var voz_pitch := 1.0 setget voz_pitch_change
var do_not_follow
var line_pos
export(float) var character_speed = 150.0
var path = []
onready var navigation_2d = get_parent().get_parent()
var motion = Vector2()
var saved = false
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _init():
	if Engine.editor_hint: return
	add_to_group("nenitos")
func _ready():
	_on_NenitoVoiceTimer_timeout()
	
func _process(delta):
	if Engine.editor_hint: return
	var walk_distance = character_speed * delta
	move_along_path(walk_distance)
	
func move_along_path(distance):
	if Engine.editor_hint: return
	var last_point = self.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			motion.x = (path[0].x - last_point.x)
			motion.y = (path[0].y - last_point.y)
			motion = motion.normalized() * character_speed
			move_and_slide(motion)
			return

		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)

	self.position = last_point
	set_process(false)

#func _draw():
#	draw_line(Vector2(0,0), motion*1000, Color.white)

func _on_Troll_follow_me(leader_position):
	if Engine.editor_hint or saved: return
	path = navigation_2d.get_simple_path(self.position, leader_position, true)
#	print(path, self.position, leader_position)
	if path.size() > 0:
		path.remove(0)
	set_process(true)

func _on_Troll_stop():
	pass # Replace with function body.
	
func explotar():
	if Engine.editor_hint: return
	$SpriteNenito.hide()
	$CPUParticles2D.emitting = true
	
func color_change(color):
	pilotin = color
	$SpriteNenito.material.set_shader_param("pilotin",color)

func voz_pitch_change(pitch):
	voz_pitch = pitch
	$AudioStreamPlayer2D.pitch_scale = pitch
	$AudioStreamPlayer2D.play()

func _on_NenitoVoiceTimer_timeout():
	if Engine.editor_hint or saved: return
	$NenitoVoiceTimer.start(rng.randi_range(10,20))
	$AudioStreamPlayer2D.play()
	
