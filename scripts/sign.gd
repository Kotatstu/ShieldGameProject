# Sign.gd (Godot 4) – gắn vào node gốc "sign" (Node2D)
extends Node2D

@export var big_sign_scene: PackedScene
@onready var detector: Area2D = $Detector
var hint_label: Label
var _player_inside := false
var _big_sign: CanvasLayer

func _ready() -> void:
	# Tìm Hint ở cùng cấp hoặc nằm cạnh Detector
	hint_label = get_node_or_null("Hint")
	if hint_label == null:
		hint_label = get_node_or_null("../Hint")  # phòng khi script gắn nhầm vào Detector
	if hint_label:
		hint_label.visible = false
	else:
		push_error("Không tìm thấy Label 'Hint' (hãy kiểm tra tên node và nơi gắn script).")

	# Kết nối tín hiệu cho Detector
	if not detector.body_entered.is_connected(_on_body_entered):
		detector.body_entered.connect(_on_body_entered)
	if not detector.body_exited.is_connected(_on_body_exited):
		detector.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_inside = true
		if hint_label: hint_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_inside = false
		if hint_label: hint_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if _player_inside and event.is_action_pressed("interact"):
		if _big_sign: _close_big_sign()
		else: _open_big_sign()

func _open_big_sign() -> void:
	if big_sign_scene == null:
		push_error("Chưa gán 'big_sign_scene' trong Inspector cho Sign.")
		return
	_big_sign = big_sign_scene.instantiate()
	get_tree().current_scene.add_child(_big_sign)
	_big_sign.tree_exited.connect(func(): _big_sign = null)

func _close_big_sign() -> void:
	if _big_sign and is_instance_valid(_big_sign):
		_big_sign.queue_free()
		_big_sign = null
