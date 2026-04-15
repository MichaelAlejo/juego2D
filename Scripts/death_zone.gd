extends Area2D

@onready var respawn_point = $"../RespawnPoint"

func _on_body_entered(body):
	if body.has_method("die"):
		body.die(true)  # true = muerte por caída
		# Para que haga respawn mas rapido.
		body.velocity = Vector2.ZERO
