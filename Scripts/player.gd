extends CharacterBody2D

const SPEED = 155
const JUMP_VELOCITY = -300

@onready var animated_sprite = $AnimatedSprite2D
@onready var dust = preload("res://Scenes/dust.tscn")
@onready var deal_damage_zone = $DamageZone

var isgrounded = true
var spawn_position

var attack = null
var health = 100
var health_max = 100
var health_min = 0

func _ready():
	spawn_position = global_position

func _physics_process(delta):
	if isgrounded == false and is_on_floor() == true:
		var instance = dust.instantiate()
		instance.global_position = $Marker2D.global_position
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
		deal_damage_zone.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# ATAQUE
	if Input.is_action_just_pressed("left_mouse") and !attack:
		attack = "5_attack"
		handle_attack_animation(attack)

	# ANIMACIONES (solo si no está atacando)
	if !attack:

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

	set_damage(attack)
	move_and_slide()

func die():
	global_position = spawn_position
	velocity = Vector2.ZERO

func handle_attack_animation(attack):
	if attack:
		animated_sprite.play("5_attack")
		toggle_damage_collisions(attack)
		await animated_sprite.animation_finished
		self.attack = null


func toggle_damage_collisions(attack):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time: float
	if attack == "5_attack":
		wait_time = 0.5
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true
	
func set_damage(attack):
	var damage_to_deal: int
	if attack == "5_attack":
		damage_to_deal = 15
	Global.playerDamageAmount = damage_to_deal
