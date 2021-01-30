extends KinematicBody2D

var do_not_follow
var line_pos
export(float) var character_speed = 400.0
var path = []
onready var navigation_2d = $Navigation2D

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var walk_distance = character_speed * delta
	move_along_path(walk_distance)
	
func move_along_path(distance):
	var last_point = self.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			self.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	self.position = last_point
	set_process(false)
	
func _on_Troll_follow_me(leader_position):
#	$Tween.interpolate_property(self, "position", self.position, (position*(1-line_pos*0.05)),1, Tween.TRANS_LINEAR,Tween.EASE_OUT)
#	$Tween.start()
#	pass
	# get_simple_path is part of the Navigation2D class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = navigation_2d.get_simple_path(self.position, leader_position, false)
#	print(path, self.position, leader_position)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	path.remove(0)
	set_process(true)

func _on_Troll_stop():
	pass # Replace with function body.
