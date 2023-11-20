extends StaticBody2D

var animationPlayer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer = $AnimationPlayer
	
	if animationPlayer != null:
		animationPlayer.play("Charge")
	else:
		pass


func _physics_process(delta):

