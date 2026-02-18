extends Area2D

@onready var respawn_point = $"../RespawnPoint"

func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = respawn_point.global_position
		# Para que haga respawn mas rapido.
		body.velocity = Vector2.ZERO
