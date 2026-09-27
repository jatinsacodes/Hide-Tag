extends Control


@export var controls_menu: Panel

# Map selector scene
const MAP_SELECTOR_SCREEN = "res://scenes/map_selector.tscn"


func _on_play_button_pressed() -> void:
	# Opens the map selector
	get_tree().change_scene_to_file(MAP_SELECTOR_SCREEN)


func _on_settings_button_pressed() -> void:
	# Opens options/settings menu
	controls_menu.visible = true


func _on_quit_button_pressed() -> void:
	# Quit the game
	get_tree().quit()
