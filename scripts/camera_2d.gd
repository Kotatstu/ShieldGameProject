extends Camera2D
@export var move_distance_y: float = 300.0
var initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move_camera_by_y(offset_y: float) -> void:
	global_position.y += offset_y

func _on_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#print(body.name+ '1')
		move_camera_by_y(-210)


func _on_down_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#print(body.name+ '2')
		move_camera_by_y(210)
