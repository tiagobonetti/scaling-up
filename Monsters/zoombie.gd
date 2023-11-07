extends StaticBody2D

##const EnemyDeathEffect = preload(death effect scene to be added)

#var ACCELERATION = 200
var MAX_SPEED = 50
#var FRICTION = 200

#enum {
#	IDLE,
#	WANDER,
#	CHASE
#}

#var velocity = Vector2.ZERO
#var knockback = Vector2.ZERO

#var state = CHASE

var animationPlayer = null

func _ready():
	animationPlayer = $AnimationPlayer
	
	animationPlayer.play("Idle")
	#var stats = $Stats

var player = null
var player_chase = false

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/MAX_SPEED
		
		if (player.position.x - position.x) < 0:
			animationPlayer.play("RunLeft")
		elif (player.position.x - position.x) > 0:
			animationPlayer.play("RunRight")
	else:
		animationPlayer.play("Idle")
#	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
#	knockback = move_and_collide(knockback)
#
#	match state:
#		IDLE:
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#
#		WANDER:
#			pass
#
#		CHASE:
#			pass
#
#
#func seek_player():
#	pass
#
#	##hitbox function
#
#	##health function


