extends Area2D

func _ready():
	$AnimatedSprite2D.play("orange_fire")
	$PointLightOrange.visible = true
	$PointLightBlue.visible = false

func _on_body_entered(body: Node2D):
	Checkpoint.last_position = global_position + Vector2(0, -20)
	$AnimatedSprite2D.play("blue_fire")
	$PointLightOrange.visible = false
	$PointLightBlue.visible = true
