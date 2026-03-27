extends CharacterBody2D

@export var speed = 50
var direction = -1
var dead = false

func _physics_process(delta):

	if dead:
		return

	velocity.x = speed * direction
	move_and_slide()

	# DETECTAR COLISION CON PLAYER
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.has_method("die"):
			body.die()

	if is_on_wall():
		direction *= -1
		$AnimatedSprite2D.flip_h = direction > 0

	if $AnimatedSprite2D.animation != "walk":
		$AnimatedSprite2D.play("1 - walk")
