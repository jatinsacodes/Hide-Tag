extends CharacterBody2D

var speed = 300
var jump_velocity = -400
var climb_speed = 150

# True means this player is currently the seeker
var is_seeker = false

# True means this player cannot move
var is_frozen = false

# Stops the tag from happening agein and while players overlap are in contact
var can_tag = false
#Decides if the players can climb or not
var can_climb = false

@export var player_two: CharacterBody2D
@export var label_p1: Label
@export var label_p2: Label

func _ready() -> void:
	# Randomly pick which player starts as seeker
	if randi() % 2 == 0:
		is_seeker = true
		player_two.is_seeker = false
	else:
		is_seeker = false
		player_two.is_seeker = true

	# Updating the labels to show starting roles
	update_labels()

	# Wait 1 second before allowing tagging when game starts
	await get_tree().create_timer(1.0).timeout
	can_tag = true

func update_labels() -> void:
	# Update the screen to match current roles and change their colours
	if is_seeker:
		label_p1.text = "Player 1: Seeker"
		label_p2.text = "Player 2: Hider"
	else:
		label_p1.text = "Player 1: Hider"
		label_p2.text = "Player 2: Seeker"

func _physics_process(delta: float) -> void:
	# Check if player two is overlapping and tag is allowed
	if can_tag and $Area2D.overlaps_body(player_two):
		can_tag = false

		# Swap both players roles
		is_seeker = !is_seeker
		player_two.is_seeker = !player_two.is_seeker

		# Update the screen to show new roles
		update_labels()

		# Freeze the new seeker for 5 seconds
		if is_seeker:
			is_frozen = true
			await get_tree().create_timer(5.0).timeout
			is_frozen = false
		else:
			player_two.is_frozen = true
			await get_tree().create_timer(5.0).timeout
			player_two.is_frozen = false

		# Allow tagging again
		can_tag = true

	# If frozen only apply gravity no movement allowed
	if is_frozen:
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = 0
		move_and_slide()
		return
	
	#Climbing the ladder
	if can_climb:
		velocity.y = 0
		if Input.is_key_pressed(KEY_W):
			velocity.y = -climb_speed
		if Input.is_key_label_pressed(KEY_S):
			velocity.y = climb_speed
	else:
		# Gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Jump with W key
		if Input.is_key_pressed(KEY_W) and is_on_floor():
			velocity.y = jump_velocity

	# Left and right movement
	var direction := 0.0
	if Input.is_key_pressed(KEY_A):
		direction -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction += 1.0

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Move down with S key
	if Input.is_key_pressed(KEY_S):
		position.y += 1

	move_and_slide()
