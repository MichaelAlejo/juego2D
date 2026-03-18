extends CharacterBody2D

@export var speed := 50
var direction := -1

@onready var floor_check = $FloorCheck
@onready var sprite = $AnimatedSprite2D

var can_flip := true
var flip_cooldown := 3.0
var flip_timer := 0.0

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += 500 * delta
	
	# Movimiento
	velocity.x = direction * speed
	
	# Timer de flip
	if not can_flip:
		flip_timer -= delta
		if flip_timer <= 0:
			can_flip = true
	
	# Detectar suelo
	if not floor_check.is_colliding() and can_flip:
		flip()
	
	# Detectar pared
	if is_on_wall() and can_flip:
		flip()
	
	move_and_slide()
	update_sprite()

func flip():
	direction *= -1
	floor_check.position.x *= -1
	
	can_flip = false
	flip_timer = flip_cooldown

func update_sprite():
	# Animación de caminar
	if is_on_floor() and abs(velocity.x) > 0:
		if sprite.animation != "1 - walk":
			sprite.play("1 - walk")
	
	# Volteo del sprite
	sprite.flip_h = direction > 0
