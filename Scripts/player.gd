extends CharacterBody2D

const SPEED = 155
const JUMP_VELOCITY = -300

@onready var animated_sprite = $AnimatedSprite2D
@onready var dust = preload("res://Scenes/dust.tscn")
var isgrounded = true



func _physics_process(delta):
	
	
	if isgrounded == false and is_on_floor() == true:
		var instance = dust.instantiate()
		instance.global_position =  $Marker2D.global_position
		get_parent().add_child(instance)
	 
	isgrounded = is_on_floor()

	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Saltar
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = 0


	# ANIMACIONES (sin reiniciar)

	if not is_on_floor():

		if velocity.y < 0:
			if animated_sprite.animation != "3_jump":
				animated_sprite.play("3_jump")

		else:
			if animated_sprite.animation != "4_fall":
				animated_sprite.play("4_fall")

	else:

		if direction != 0:
			if animated_sprite.animation != "2_move":
				animated_sprite.play("2_move")

		else:
			if animated_sprite.animation != "1_idle":
				animated_sprite.play("1_idle")


	move_and_slide()
