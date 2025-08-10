extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const SNAP_LENGTH = 8.0          # Khoảng cách snap để bám mặt đất
const MAX_SLOPE_ANGLE = 45.0     # Góc dốc tối đa 
const gravity = 900.0            # Lực trọng trường
var climbing: bool = false
var current_rope: Area2D = null
var onRope = false
#Dash stuff
var dash_distance := 50.0
var dash_duration := 0.2
var is_dashing := false
var dash_direction := Vector2.ZERO
var dash_timer := 0.0
var is_wall_sliding = false       #For wall sliding
var friction = 70                #For wall sliding
@export var climb_speed: float = 100.0


@onready var animated_sprite = $Node2D/CharacterAnimation

func _ready() -> void:
	pass

#called every frame
func _process(delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
# Drop down on platform
	if Input.is_action_pressed("Down"):
		position.y += 1
# on Rope
	if onRope:
		if Input.is_action_pressed("Up"):
			velocity.y = -SPEED * 1
		elif Input.is_action_pressed("Down"):
			velocity.y = SPEED * 1
		else:
			velocity.y = 0
# Add the gravity.
	elif  not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()):
		velocity.y = JUMP_VELOCITY
		

		
	# Get the input direction and handle the movement/deceleration.
	#-1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	#flip
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	
	#play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else: 
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	#move the player
	if direction:
		velocity.x = direction * SPEED + delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Handle dash when pressed F
	if Input.is_action_just_pressed("Dash"):
		start_dash()
		
	#Move every frame with higher speed when dashing
	if is_dashing:
		var dash_speed = dash_distance / dash_duration
		if dash_direction != Vector2.ZERO:
			position += dash_direction * dash_speed * delta
			dash_timer -= delta
			if dash_timer <= 0.0:
				is_dashing = false
		else:#if standing still, wont dash
			pass
	
	wall_slide()
	
	move_and_slide()

func start_dash():
	is_dashing = true
	dash_timer = dash_duration
	dash_direction = get_input_direction()

#Get the direction on input
func get_input_direction() -> Vector2:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	return direction.normalized()

func wall_slide():
	if is_on_wall() and not is_on_floor() and velocity.y > 0:
		is_wall_sliding = true
		velocity.y = friction
	else:
		is_wall_sliding = false
