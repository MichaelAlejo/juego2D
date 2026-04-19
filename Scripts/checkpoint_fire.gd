extends Area2D

func _ready():
	$AnimatedSprite2D.play("orange_fire")


func _on_body_entered(body: Node2D):
	Checkpoint.last_position = global_position + Vector2(0, -20)
	$AnimatedSprite2D.play("blue_fire")
