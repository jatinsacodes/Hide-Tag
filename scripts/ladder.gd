extends Area2D

@export var player_one: CharacterBody2D
@export var player_two: CharacterBody2D
@export var ladder_picture: TextureRect
@export var seeker_wait_timer: Timer

#Seeker can climb ladder yet
var seeker_allowed = true

func _physics_process(_delta: float) -> void:
	#Find out who hider and seeker is
	var seeker
	var hider
	if player_one.is_seeker:
		seeker = player_one
		hider = player_two
	else:
		seeker = player_two
		hider = player_one
	#Hider can climb whenever
	hider.can_climb = overlaps_body(hider)
	#Seeker can only climb after 5 seconds ended
	seeker.can_climb = overlaps_body(seeker) and seeker_allowed


func _on_body_entered(body: Node2D) -> void:
	#Ignore anything else
	if body != player_one and body != player_two:
		return
	#When the hider gets on the ladder
	if not body.is_seeker:
		#Turning the ladders colour
		ladder_picture.modulate = body.modulate
		#Seeker can't get on yet and has to wait
		seeker_allowed = false
		seeker_wait_timer.stop()
	elif seeker_allowed:
		#Turns the ladder to the seeker colour
		ladder_picture.modulate = body.modulate


func _on_body_exited(body: Node2D) -> void:
	#Ignore anything else
	if body != player_one and body != player_two:
		return
	#Start the 5 second timer after hider gets of
	if not body.is_seeker:
		seeker_wait_timer.start()
	elif seeker_allowed:
		ladder_picture.modulate = Color("888888")


func _on_seeker_wait_timer_timeout() -> void:
	#Seeker can go on the ladder now
	seeker_allowed = true
	#Ladder back to grey
	ladder_picture.modulate = Color("888888")
