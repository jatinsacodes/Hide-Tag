extends Control


func _on_easy_button_pressed() -> void:
	# Players play easy map
	get_tree().change_scene_to_file("res://scenes/map_2.tscn")


func _on_medium_button_pressed() -> void:
	# Players play medium map
	get_tree().change_scene_to_file("res://scenes/map_1.tscn")


func _on_hard_button_pressed() -> void:
	# Players play hard map
	get_tree().change_scene_to_file("res://scenes/map_3.tscn")
