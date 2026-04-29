extends CanvasLayer

# 🔁 REINICIAR JUEGO
func _on_retry_pressed():
	get_tree().paused = false
	
	if Global.last_scene_path != "":
		get_tree().change_scene_to_file(Global.last_scene_path)


# 🏠 IR AL MENÚ PRINCIPAL
func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
