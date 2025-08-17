extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Menu"):
		get_tree().change_scene_to_file("res://scences/main_node.tscn")

func _on_start_game_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scences/main_node.tscn")


func _on_options_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
