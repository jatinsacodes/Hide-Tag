extends Node2D

#How long the rounds are
const round_time = 300.0
var time_left = round_time

#When the colour changes of the timer
const yellow_time = 180
const red_time = 60
const seconds_per_minute = 60

#Timer colours
const green = Color("33ff33")
const yellow = Color("f5c542")
const red = Color("ff3333")

#Layers so the hider can go behind the hiding boxes
const seeker_layer = 2
const hider_layer = 0

#Main menu scene
const main_menu_screen = "res://scenes/main_menu.tscn"

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
	
	var minutes = int(total_seconds/float(seconds_per_minute))
	var seconds = total_seconds % seconds_per_minute
	
	#Showing time in this format 3:05
	time_label.text = str(minutes) + ":" +str(seconds).pad_zeros(2)
	
	#Changing time colour based on time left
	if total_seconds > yellow_time:
		time_label.add_theme_color_override("font_color", green)
	elif total_seconds > red_time:
		time_label.add_theme_color_override("font_color", yellow)
	else:
		time_label.add_theme_color_override("font_color", red)
	#Only the hider can hide behind the boxes
	for player in [player_one, player_two]:
		if player.is_seeker:
			player.z_index = seeker_layer
		else:
			player.z_index = hider_layer
	
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
	get_tree().change_scene_to_file(main_menu_screen)

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
	get_tree().change_scene_to_file(main_menu_screen)
	
