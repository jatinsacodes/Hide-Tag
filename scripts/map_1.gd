extends Node2D

#How long the rounds are
var time_left = 10.0

#Game over decider
var game_over = false

@export var time_label: Label
@export var pause_button: Button
@export var player_one: CharacterBody2D
@export var player_two: CharacterBody2D
@export var p1_spawn: Marker2D
@export var p2_spawn: Marker2D
@export var pause_menu: Panel
@export var game_over_menu: Panel
@export var winner_label: Label
@export var controls_menu: Panel

func _process(delta:float) -> void:
	#Taking away the time
	if time_left > 0:
		time_left -= delta
	
	#Time cannot reach 0
	if time_left < 0:
		time_left = 0
	
	if time_left <= 0 and not game_over:
		end_round()
	
	#Turning time into whole seconds and then turning into minutes and seconds
	var total_seconds = int(time_left)
	
	var minutes = int(total_seconds/60.0)
	var seconds = total_seconds % 60
	
	#Showing time in this format 3:05
	time_label.text = str(minutes) + ":" +str(seconds).pad_zeros(2)
	
	#Changing time colour based on time left
	if total_seconds > 180:
		time_label.add_theme_color_override("font_color", Color("33ff33"))
	elif total_seconds > 60:
		time_label.add_theme_color_override("font_color", Color("f5c542"))
	else:
		time_label.add_theme_color_override("font_color", Color("ff3333"))
	#Only the hider can hide behind the boxes
	if player_one.is_seeker:
		player_one.z_index = 2
		player_two.z_index = 0
	else:
		player_one.z_index = 0
		player_two.z_index = 2
	
func _on_pause_button_pressed() -> void:
	#Pausing the game
	get_tree().paused = true
	pause_menu.visible = true

func _on_fall_zone_body_entered(body: Node2D) -> void:
	if body == player_one:
		player_one.global_position = p1_spawn.global_position
		player_one.velocity = Vector2.ZERO
	elif body == player_two:
		player_two.global_position = p2_spawn.global_position
		player_two.velocity = Vector2.ZERO

func _on_resume_button_pressed() -> void:
	#Hide the pause menu
	pause_menu.visible = false
	get_tree().paused = false
	
func _on_options_button_pressed() -> void:
	#Options button
	controls_menu.visible = true

func _on_home_button_pressed() -> void:
	#Home button
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func end_round() -> void:
	#Remembers round only happens once
	game_over = true
	
	##Check who won
	if player_one.is_seeker:
		winner_label.text = "Player 2 wins!"
		winner_label.add_theme_color_override("font_color", player_two.modulate)
	else:
		winner_label.text = "Player 1 wins!"
		winner_label.add_theme_color_override("font_color", player_one.modulate)
	
	#Hide the pause menu
	pause_button.visible = false
	
	#Show that the game is over freeze game
	game_over_menu.visible = true
	get_tree().paused = true

func _on_play_again_button_pressed() -> void:
	#Play the game again
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	#Go the main menu screen
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
