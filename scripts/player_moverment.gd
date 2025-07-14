extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite = $Node2D/CharacterAnimation

func _ready() -> void:
	pass

#called every frame
func _process(delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#-1, 0, 0
	var direction := Input.get_axis("move_left", "move_right")
	
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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
