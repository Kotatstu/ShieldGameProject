extends Node2D

@export var tween_time: float = 0     # thời gian chuyển
@export var zoom_on_sign: bool = true   # có phóng to khi đọc bảng không
@export var zoom_amount: float = 6    # <1.0 = phóng to (0.6 ≈ 1.67x)

@onready var detector: Area2D  = $Detector
@onready var sign_cam: Camera2D = $SignCamera

var prev_cam: Camera2D = null
var busy := false

func _ready() -> void:
	sign_cam.enabled = false

func _on_enter(body: Node) -> void:
	if busy: return
	if not body.is_in_group("player"): return
	busy = true

	# Lưu camera đang dùng (camera cố định của world)
	prev_cam = get_viewport().get_camera_2d()

	# Đặt camera bảng ở vị trí bảng (có thể cộng offset nếu muốn lệch một chút)
	sign_cam.global_position = global_position
	# Bắt đầu bằng zoom của camera cũ để chuyển mượt
	if prev_cam:
		sign_cam.zoom = prev_cam.zoom

	sign_cam.enabled = true
	sign_cam.make_current()

	# Tween zoom (tuỳ chọn)
	if zoom_on_sign:
		var tw = get_tree().create_tween()
		tw.tween_property(sign_cam, "zoom", Vector2(zoom_amount, zoom_amount), tween_time)\
		  .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		# không zoom thì cho phép thoát ngay
		busy = false

func _on_exit(body: Node) -> void:
	if not body.is_in_group("player"): return
	if prev_cam == null: return

	# Thu zoom về như cũ rồi trả lại camera world
	var tw = get_tree().create_tween()
	tw.tween_property(sign_cam, "zoom", prev_cam.zoom, tween_time)\
	  .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_callback(Callable(self, "_restore"))

func _restore() -> void:
	if prev_cam:
		prev_cam.make_current()
	sign_cam.enabled = false
	prev_cam = null
	busy = false
