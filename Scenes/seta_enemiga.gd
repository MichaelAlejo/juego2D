extends CharacterBody2D

var gravity = 10
var velocity = Vector2 (0,0)
var speed = 32 

func _ready():
	$AnimatedSprite2D.play("2_walk")
