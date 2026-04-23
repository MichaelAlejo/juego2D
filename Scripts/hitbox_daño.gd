extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body and body.has_method("take_damage"):
		body.take_damage(30)
		
		if body.has_method("apply_knockback"):
			body.apply_knockback(global_position)
