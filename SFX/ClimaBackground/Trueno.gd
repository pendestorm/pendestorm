extends ColorRect

onready var timer = $Timer
onready var anim_player = $AnimationPlayer
onready var rng = RandomNumberGenerator.new()
onready var truenos = anim_player.get_animation_list()

func _ready():
	rng.randomize()
	for i in range(100):
		print(rng.randi_range(0,truenos.size()-1))

func _on_Timer_timeout():
	timer.start(rng.randf_range(10,25))
	anim_player.play(truenos[rng.randi_range(0,truenos.size()-1)])
