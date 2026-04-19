extends Area2D

@onready var respawn_point = $"../RespawnPoint"

func _on_body_entered(body):
	if body.has_method("die"):
		body.die(true)  # true = muerte por caída
		
		# 2. Inmediatamente después, lo frenamos y lo movemos
		# (Esto sobreescribirá cualquier movimiento que haga die())
		# Para que haga respawn mas rapido.
		body.velocity = Vector2.ZERO
		
		if Checkpoint.last_position != null:
			body.global_position = Checkpoint.last_position
		else:
			body.global_position = respawn_point.global_position
