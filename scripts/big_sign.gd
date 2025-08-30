extends CanvasLayer
@onready var overlay: ColorRect = $Overlay
var _was_paused := false

func _ready() -> void:
	overlay.anchor_left = 0; overlay.anchor_top = 0
	overlay.anchor_right = 1; overlay.anchor_bottom = 1
	overlay.color = Color(0,0,0,0.65)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP

	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_was_paused = get_tree().paused
	get_tree().paused = true

func _unhandled_input(e: InputEvent) -> void:
	if e.is_action_pressed("interact") or e.is_action_pressed("ui_cancel"):
		get_tree().paused = _was_paused
		queue_free()

func _exit_tree() -> void:
	if get_tree(): get_tree().paused = _was_paused
