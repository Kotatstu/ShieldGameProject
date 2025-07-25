extends Area2D

@onready var animated_sprite = $press
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#print(body.name+ '1')
		animated_sprite.play("press")
	if body.is_in_group("rock"):
		#print(body.name+ '1')
		animated_sprite.play("press")
	if body.is_in_group("shield"):
		#print(body.name+ '1')
		animated_sprite.play("press")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		#print(body.name+ '2')
		animated_sprite.stop()
