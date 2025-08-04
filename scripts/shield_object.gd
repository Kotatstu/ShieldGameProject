extends Area2D

signal shield_throw
signal shield_stop
signal shield_retrieve

var velocity: Vector2 = Vector2.ZERO
var speed:= 250.0
@export var is_thrown := false
var shield_start_pos: Vector2
var max_distant = 150


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	

func _input(event):
	#Emit throw shield signal when left click
	if event.is_action_pressed("left_click") and is_thrown == false:
		shield_throw.emit()
	elif event.is_action_pressed("left_click") and is_thrown == true:
		pass
	
	#Emit retrieve shield signal when right click
	if event.is_action_pressed("right_click"):
		shield_retrieve.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	#Emit signal when user left click
	if velocity == Vector2.ZERO:
		shield_stop.emit()
		
	

func _physics_process(delta):
	if is_thrown == true:
		position += velocity * delta
		
		var traveled = global_position.distance_to(shield_start_pos)
		if(traveled > max_distant):
			is_thrown = false


	
# Throw the shield at the pos of mouse, stop when reach wall or max length
func throw_shield_at(target_pos: Vector2):
	if is_thrown == true:
		#Flip shield sprite shield way when thrown
		rotate(0.5*PI)
		
		shield_start_pos = global_position
		velocity = (target_pos - global_position).normalized() * speed
		
func stop_shield():
	velocity = Vector2.ZERO
