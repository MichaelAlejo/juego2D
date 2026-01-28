class_name Player
extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 100.0
var state : String = "1_idle"

@onready var animaciones : AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	animaciones.play("1_idle")


func _process(delta):
	# INPUT
	direction.x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	direction.y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")

	# MOVIMIENTO
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * move_speed
	else:
		velocity = Vector2.ZERO

	# ANIMACIONES
	if direction == Vector2.ZERO:
		if state != "1_idle":
			state = "1_idle"
			animaciones.play(state)
	else:
		if state != "2_move":
			state = "2_move"
			animaciones.play(state)


func _physics_process(delta):
	move_and_slide()
