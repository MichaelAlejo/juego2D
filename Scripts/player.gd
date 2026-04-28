extends CharacterBody2D

const SPEED = 155
const JUMP_VELOCITY = -300

@onready var animated_sprite = $AnimatedSprite2D
@onready var dust = preload("res://Scenes/dust.tscn")
@onready var deal_damage_zone = $DamageZone
@onready var respawn_point = get_parent().get_node("RespawnPoint")

var isgrounded = true
var attack = null

# VIDA
var health = 100
var health_max = 100
var health_min = 0

var is_dead = false
var invulnerable = false
var respawn_health_penalty = 10


func _physics_process(delta):
	if isgrounded == false and is_on_floor() == true:
		var instance = dust.instantiate()
		instance.global_position = $Marker2D.global_position
		get_parent().add_child(instance)
	 
	isgrounded = is_on_floor()

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
		deal_damage_zone.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("left_mouse") and !attack and !is_dead:
		attack = "5_attack"
		handle_attack_animation(attack)

	# ❗ No interrumpir animación de hit
	if !attack and !is_dead:
		if not is_on_floor():
			if velocity.y < 0:
				if animated_sprite.animation != "3 - jump":
					animated_sprite.play("3 - jump")
			else:
				if animated_sprite.animation != "4 - fall":
					animated_sprite.play("4 - fall")
		else:
			if direction != 0:
				if animated_sprite.animation != "2 - move":
					animated_sprite.play("2 - move")
			else:
				if animated_sprite.animation != "1 - idle":
					animated_sprite.play("1 - idle")

	move_and_slide()


# =========================
# ❤️ VIDA
# =========================

func take_damage(amount: int):
	if invulnerable or is_dead:
		return
		
	health -= amount
	health = clamp(health, health_min, health_max)

	# 🔥 Estado hit
	attack = "hit"
	invulnerable = true

	# ▶️ Animación de daño
	animated_sprite.play("6 - hit")

	# Parar movimiento
	velocity = Vector2.ZERO

	# ⏱️ Esperar (ajusta si quieres)
	await get_tree().create_timer(0.3).timeout

	# 🔓 Volver a estado normal
	attack = null

	if health <= health_min:
		die(false)
	else:
		start_invulnerability()


func die(by_fall: bool):
	if is_dead:
		return
		
	is_dead = true

	if by_fall:
		health -= respawn_health_penalty

	health = max(health, health_min)

	global_position = respawn_point.global_position
	velocity = Vector2.ZERO

	if health <= health_min:
		health = health_max

	is_dead = false

	start_invulnerability()


func start_invulnerability():
	await get_tree().create_timer(1.0).timeout
	invulnerable = false


func heal(amount: int):
	health += amount
	health = clamp(health, health_min, health_max)


# =========================
# ⚔️ ATAQUE
# =========================

func handle_attack_animation(attack):
	if attack:
		animated_sprite.play("5 - attack")
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


# =========================
# ⚡ DAÑO 
# =========================

func get_damage():
	if attack == "5_attack":
		return 25
	return 0


# =========================
# 💥 KNOCKBACK
# =========================

func apply_knockback(source_position: Vector2):
	var knockback_direction = -1 if source_position.x > global_position.x else 1
	
	velocity.x = knockback_direction * 500 
	velocity.y = -250
	
	move_and_slide()
