extends Node2D

@export var break_delay: float = 1  # Thời gian (s) trước khi vỡ
@export var respawn_delay:  float = 5.0   # thời gian chờ trước khi respawn
@export var trap_scene:     PackedScene = preload("res://scences/PlatformTrap.tscn")
@onready var sprite: Sprite2D                  = $Sprite2D
@onready var body_collision: CollisionShape2D = $Body/CollisionShape2D
@onready var detector: Area2D                  = $Detector
@onready var timer: Timer                     = $Timer
var time = 1
var triggered: bool = false

func _ready() -> void:
	set_process(false)
	detector.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)
func _process(delta):
	time += 1
	$Sprite2D.position += Vector2(0, sin(time)*1.5)
	
func _on_body_entered(body: Node) -> void:
	#print(">>> Trap: body_entered:", body.name)
	if triggered:
		return
	if body.is_in_group("player"):
		set_process(true)
		#print(">>> Trap: triggering break timer")
		triggered = true
		timer.start(break_delay)

func _on_timer_timeout() -> void:
	#print(">>> Trap: timer timeout, disabling collision")
	body_collision.disabled = true
	sprite.modulate = Color(1, 1, 1, 0.5)

	# tạo timer động để respawn
	var respawner = get_tree().create_timer(respawn_delay)
	respawner.timeout.connect(func() -> void:
		# ← bắt đầu block của lambda, lùi vào 4 spaces
		var new_trap = trap_scene.instantiate()	
		get_parent().add_child(new_trap)
		new_trap.global_position = global_position)  # ← kết thúc block
	
	#print(">>> Trap: queue_free()")
	queue_free()
