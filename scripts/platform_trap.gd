extends Node2D


@export var break_delay: float = 0.3  # Thời gian (s) trước khi vỡ
@export var respawn_delay:  float = 5.0   # thời gian chờ trước khi respawn
@export var trap_scene:     PackedScene = preload("res://scences/PlatformTrap.tscn")
@onready var sprite: Sprite2D                  = $Sprite2D
@export var break_delay: float = 0.5
@export var respawn_delay: float = 2.0
@export var trap_scene: PackedScene = preload("res://scences/PlatformTrap.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var body_collision: CollisionShape2D = $Body/CollisionShape2D
@onready var detector: Area2D = $Detector
@onready var timer: Timer = $Timer

var t := 0.0
var triggered := false

func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	t += delta * 1000
	sprite.position.y = sin(t) * 1

func _on_body_entered(body: Node) -> void:
	if triggered:
		return
	if body.is_in_group("player"):
		triggered = true
		set_process(true)
		timer.start(break_delay)

func _on_break() -> void:
	# “vỡ”:
	body_collision.disabled = true
	detector.monitoring = false
	sprite.modulate.a = 0

	# đợi 5 giây rồi “respawn”
	await get_tree().create_timer(respawn_delay).timeout

	# reset về trạng thái ban đầu
	body_collision.disabled = false
	detector.monitoring = true
	sprite.modulate.a = 1.0
	triggered = false
	set_process(false)
