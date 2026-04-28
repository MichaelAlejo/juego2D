extends Control

@onready var panel = $Panel
@onready var retry_button = $Panel/Retry
@onready var menu_button = $Panel/Menu

func _ready():
	# Ocultar Game Over al inicio
	panel.visible = false
	
	# Conectar botones (por si no lo haces desde el editor)
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)


# 💀 LLAMAR ESTA FUNCIÓN CUANDO EL JUGADOR MUERA
func game_over():
	panel.visible = true
	get_tree().paused = true


# 🔁 REINICIAR JUEGO
func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


# 🏠 IR AL MENÚ PRINCIPAL
func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
