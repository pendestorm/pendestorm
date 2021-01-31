tool
extends KinematicBody2D

export var pilotin : Color setget color_change
var do_not_follow
var line_pos
export(float) var character_speed = 150.0
var path = []
onready var navigation_2d = get_parent().get_parent()
var motion = Vector2()
var saved = false

func _init():
	if Engine.editor_hint: return
	add_to_group("nenitos")
func _ready():
	pass
	
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
	if Engine.editor_hint: return
	path = navigation_2d.get_simple_path(self.position, leader_position, true)
#	print(path, self.position, leader_position)
	if path.size() > 0:
		path.remove(0)
	set_process(true)

func _on_Troll_stop():
	pass # Replace with function body.
	
func explotar():
	if Engine.editor_hint: return
	$Sprite.hide()
	$CPUParticles2D.emitting = true
	
func color_change(color):
	pilotin = color
	$Sprite.material.set_shader_param("pilotin",color)
