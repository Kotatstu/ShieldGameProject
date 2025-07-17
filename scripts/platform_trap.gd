extends Node2D

@export var break_delay: float = 2  # Thời gian (s) trước khi vỡ
@onready var sprite: Sprite2D                  = $Sprite2D
@onready var body_collision: CollisionShape2D = $Body/CollisionShape2D
@onready var detector: Area2D                  = $Detector
@onready var timer: Timer                     = $Timer

var triggered: bool = false

func _ready() -> void:
	detector.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body: Node) -> void:
	print(">>> Trap: body_entered:", body.name)
	if triggered:
		return
	if body.is_in_group("player"):
		print(">>> Trap: triggering break timer")
		triggered = true
		timer.start(break_delay)

func _on_timer_timeout() -> void:
	print(">>> Trap: timer timeout, disabling collision")
	body_collision.disabled = true
	sprite.modulate = Color(1, 1, 1, 0.5)
	# Chờ thêm 1s để hiện hiệu ứng rồi xóa
	await get_tree().create_timer(1.0).timeout
	print(">>> Trap: queue_free()")
	queue_free()
