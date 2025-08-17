extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $press

var _ended := false
var _game_over_canvas: CanvasLayer
var _label: Label

func _on_body_entered(body: Node2D) -> void:
	if _ended:
		return
	if body.is_in_group("player"):
		animated_sprite.play("press")
		_show_countdown()
		_ended = true

func _show_countdown() -> void:
	# CanvasLayer UI
	_game_over_canvas = CanvasLayer.new()
	_game_over_canvas.layer = 100
	get_tree().root.add_child(_game_over_canvas)

	# Label chiếm màn hình
	_label = Label.new()
	_label.anchor_left = 0.0
	_label.anchor_top = 0.0
	_label.anchor_right = 1.0
	_label.anchor_bottom = 1.0
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 72)
	_label.add_theme_color_override("font_color", Color(1, 0.2, 0.2))
	_game_over_canvas.add_child(_label)

	# Bắt đầu đếm ngược
	_start_countdown()

func _start_countdown() -> void:
	var numbers = ["3", "2", "1", "GAME OVER"]
	var delay := 1.0
	for i in range(numbers.size()):
		var t = get_tree().create_timer(i * delay)
		t.timeout.connect(func():
			_label.text = numbers[i]
			if numbers[i] == "GAME OVER":
				_schedule_quit()
		)

func _schedule_quit() -> void:
	var timer := get_tree().create_timer(1.0) # chờ thêm 5s sau khi hiện GAME OVER
	timer.timeout.connect(func ():
		get_tree().quit()
	)
