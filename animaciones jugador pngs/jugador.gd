extends CharacterBody2D

@export var speed := 65
@onready var anim := $AnimatedSprite2D

@warning_ignore("unused_parameter")
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	input_vector.y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")

	if input_vector != Vector2.ZERO:
		#  Girar sprite izquierda / derecha
		if input_vector.x < 0:
			anim.flip_h = true   # izquierda
		elif input_vector.x > 0:
			anim.flip_h = false  # derecha
		
		# Conversión a isométrico
		var iso_direction = Vector2(
			input_vector.x - input_vector.y,
			(input_vector.x + input_vector.y) / 2
		)
		
		velocity = iso_direction.normalized() * speed
		
		# Animación de movimiento
		if anim.animation != "2_move":
			anim.play("2_move")
	else:
		velocity = Vector2.ZERO
		
		# Animación idle
		if anim.animation != "1_idle":
			anim.play("1_idle")

	move_and_slide()
