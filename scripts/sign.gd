extends Node2D
##
# Sign.gd - Nhấn E để zoom vào biển báo; nhấn E lần nữa (hoặc bước ra) để trả camera về như cũ.
##

@export var tween_time: float = 0      # thời gian chuyển
@export var zoom_on_sign: bool = true    # có phóng to khi xem biển không
@export var zoom_amount: float = 6     # <1.0 = phóng to (0.6 ≈ 1.67x)
@export var camera_offset: Vector2 = Vector2.ZERO # lệch cam một chút nếu cần

@onready var detector: Area2D    = $Detector
@onready var sign_cam: Camera2D  = $SignCamera
@onready var hint: Label         = get_node_or_null("Hint") # optional

var prev_cam: Camera2D = null     # camera world hiện tại
var in_range := false             # player đang đứng trong vùng
var reading  := false             # đang “đọc biển” (đã chuyển camera)
var busy     := false             # khoá tween

func _ready() -> void:
	sign_cam.enabled = false
	if hint: hint.visible = false
	set_process_input(true)

func _on_enter(body: Node) -> void:
	if not body.is_in_group("player"): return
	in_range = true
	if hint: hint.visible = true

func _on_exit(body: Node) -> void:
	if not body.is_in_group("player"): return
	in_range = false
	if hint: hint.visible = false
	# Nếu đang đọc mà rời vùng -> trả về camera cũ
	if reading and not busy:
		_exit_read()

func _input(event: InputEvent) -> void:
	if not in_range: return
	if busy: return
	if event.is_action_pressed("interact"):
		if not reading:
			_enter_read()
		else:
			_exit_read()

func _enter_read() -> void:
	busy = true
	reading = true
	if hint: hint.visible = false

	# Lưu camera hiện tại (camera world cố định)
	prev_cam = get_viewport().get_camera_2d()

	# Đặt vị trí camera bảng
	sign_cam.global_position = global_position + camera_offset

	# Bắt đầu bằng zoom của camera cũ để mượt
	if prev_cam:
		sign_cam.zoom = prev_cam.zoom

	sign_cam.enabled = true
	sign_cam.make_current()

	if zoom_on_sign:
		var tw = get_tree().create_tween()
		tw.tween_property(sign_cam, "zoom", Vector2(zoom_amount, zoom_amount), tween_time)\
		  .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await tw.finished
	busy = false

func _exit_read() -> void:
	if prev_cam == null:
		# fallback: nếu vì lý do gì không có prev_cam, tắt camera bảng luôn
		sign_cam.enabled = false
		reading = false
		busy = false
		return

	busy = true
	if zoom_on_sign:
		var tw = get_tree().create_tween()
		tw.tween_property(sign_cam, "zoom", prev_cam.zoom, tween_time)\
		  .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await tw.finished

	# Trả lại camera world
	prev_cam.make_current()
	sign_cam.enabled = false
	prev_cam = null
	reading = false
	busy = false
	if in_range and hint:
		hint.visible = true  # còn đứng trong vùng thì hiện gợi ý lại
