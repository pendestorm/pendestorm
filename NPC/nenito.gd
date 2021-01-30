extends KinematicBody2D

var do_not_follow
var line_pos
export(float) var character_speed = 150.0
var path = []
onready var navigation_2d = get_parent().get_parent()
var motion = Vector2()
func _init():
	add_to_group("nenitos")
func _ready():
	pass
	
func _process(delta):
	var walk_distance = character_speed * delta
	move_along_path(walk_distance)
	
func move_along_path(distance):
	var last_point = self.position
	update()
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			motion.x = (path[0].x - last_point.x)
			motion.y = (path[0].y - last_point.y)
			motion = motion.normalized() * character_speed
			move_and_slide(motion)
			update()
			return

		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)

	self.position = last_point
	set_process(false)

#func _draw():
#	draw_line(Vector2(0,0), motion*1000, Color.white)

func _on_Troll_follow_me(leader_position):
	path = navigation_2d.get_simple_path(self.position, leader_position, true)
#	print(path, self.position, leader_position)
	if path.size() > 0:
		path.remove(0)
	set_process(true)

func _on_Troll_stop():
	pass # Replace with function body.
	
func explotar():
	$Sprite.hide()
	$CPUParticles2D.emitting = true
