extends CharacterBody2D

#Player speed
var speed = 300
#Player jump velocity
var jump_velocity = -400
#Player climb speed for ladder
var climb_speed = 150
#Tagging mechnaism for players
var bounce_fade = 700
var push_x = 0

# Set by player one's script when roles are assigned or swapped
var is_seeker = false

# Set by player one's script when this player needs to be frozen
var is_frozen = false
#Decides if the players can climb or not
var can_climb = false

func _physics_process(delta: float) -> void:
	#Player roles above them
	$RoleLabel.text = "SEEKER"
	$RoleLabel.visible = is_seeker
	# If frozen only apply gravity so player falls no movement
	if is_frozen:
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = push_x
		push_x = move_toward(push_x, 0, bounce_fade * delta)
		move_and_slide()
		return
	
	if can_climb:
		velocity.y = 0
		if Input.is_key_pressed(KEY_UP):
			velocity.y = -climb_speed
		if Input.is_key_label_pressed(KEY_DOWN):
			velocity.y = climb_speed
	else:
		# Gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Jump with up arrow
		if Input.is_key_pressed(KEY_UP) and is_on_floor():
			velocity.y = jump_velocity

	# Left and right movement
	var direction := 0.0
	if Input.is_key_pressed(KEY_LEFT):
		direction -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		direction += 1.0

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Move down with down arrow
	if Input.is_key_pressed(KEY_DOWN):
		position.y += 1
	
	#Add bounce on top of the normal movement
	velocity.x += push_x
	push_x = move_toward(push_x, 0, bounce_fade * delta)
	move_and_slide()
