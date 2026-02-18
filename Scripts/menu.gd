extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/1_map.scn")


func _on_controls_pressed() -> void:
	print("Controls Pressed")


func _on_exit_pressed() -> void:
	get_tree().quit()
