extends Control

@export var controls_menu: Panel

func _on_play_button_pressed() -> void:
	#Opens map selector
	get_tree().change_scene_to_file("res://scenes/map_selector.tscn")

func _on_settings_button_pressed() -> void:
	#opens options/seetings menu
	controls_menu.visible = true

func _on_quit_button_pressed() -> void:
	#Quit the game
	get_tree().quit()
