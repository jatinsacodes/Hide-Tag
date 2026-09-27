extends Control

# Scenes for each map
const EASY_MAP = "res://scenes/map_2.tscn"
const MEDIUM_MAP = "res://scenes/map_1.tscn"
const HARD_MAP = "res://scenes/map_3.tscn"


func _on_easy_button_pressed() -> void:
	# Players play easy map
	get_tree().change_scene_to_file(EASY_MAP)


func _on_medium_button_pressed() -> void:
	# Players play medium map
	get_tree().change_scene_to_file(MEDIUM_MAP)


func _on_hard_button_pressed() -> void:
	# Players play hard map
	get_tree().change_scene_to_file(HARD_MAP)
