extends CharacterBody2D

@export var speed = 40
var direction = 1
var dead = false

@onready var ray = $RayCast2D
@onready var sprite = $AnimatedSprite2D


func _physics_process(delta):

	if dead:
		return

	# gravedad
	if not is_on_floor():
		velocity.y += 500 * delta

	velocity.x = speed * direction

	if not ray.is_colliding():
		turn()

	if is_on_wall():
		turn()

	move_and_slide()


func turn():
	direction *= -1
	ray.position.x *= -1
	sprite.flip_h = !sprite.flip_h


func _on_area_2d_body_entered(body):

	if body.name == "Player":

		# si el jugador viene desde arriba
		if body.velocity.y > 0 and body.global_position.y < global_position.y:
			die()
			body.jump_bounce()

		else:
			body.die()


func die():
	queue_free()
