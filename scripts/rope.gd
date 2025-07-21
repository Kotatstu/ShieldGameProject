extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Climber"):
		body.climbing = true
		body.current_rope = self

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Climber"):
		body.climbing = false
		body.current_rope = null
