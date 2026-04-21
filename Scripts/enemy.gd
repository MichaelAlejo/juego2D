extends CharacterBody2D

@export var speed = 50
var direction = -1
var dead = false

# VIDA
var health = 70
var health_max = 70
var health_min = 0

var taking_damage = false
var invulnerable = false

@export var invulnerability_time = 0.5


func _physics_process(delta):

	if dead:
		return

	# Movimiento
	velocity.x = speed * direction
	move_and_slide()

	# =========================
	# 💥 DAÑO Y EMPUJON
	# =========================
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body and body.has_method("take_damage"):
			body.take_damage(20) # <-- Daño que hace el enemigo
			
			# 2. Aplicamos el empujón
			if body.has_method("apply_knockback"):
				body.apply_knockback(global_position)
		
	# Cambiar dirección al chocar pared
	if is_on_wall():
		direction *= -1
		$AnimatedSprite2D.flip_h = direction > 0

	# Animación caminar
	if !taking_damage and $AnimatedSprite2D.animation != "1 - walk":
		$AnimatedSprite2D.play("1 - walk")


# =========================
# 🗡️ RECIBIR DAÑO DEL PLAYER
# =========================
func _on_seta_hitbox_area_entered(area):
	if dead:
		return

	if area.is_in_group("player_attack"):
		var player = area.get_parent()
		
		if player.has_method("get_damage"):
			var damage = player.get_damage()
			take_damage(damage)


func take_damage(damage):
	if invulnerable or dead:
		return

	health -= damage
	taking_damage = true
	invulnerable = true

	print(str(self), "current health is ", health)

	# Animación de daño
	$AnimatedSprite2D.play("3 - hit")

	if health <= 0:
		die()
	else:
		await get_tree().create_timer(invulnerability_time).timeout
		invulnerable = false
		taking_damage = false


# =========================
# ☠️ MUERTE DEL ENEMIGO
# =========================
func die():
	dead = true
	velocity = Vector2.ZERO
	
	$AnimatedSprite2D.play("2 - dead")

	await $AnimatedSprite2D.animation_finished
	
	queue_free()
