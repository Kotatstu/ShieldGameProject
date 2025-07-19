extends Node2D

var player_to_shield_dis = Vector2(10, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'de=lta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#On every frame, update real shield position to follow player
	if $Shield.is_thrown == false:
		var player_pos = $player.global_position
		var mouse_pos = get_global_mouse_position()
		
		# Direction from player to mouse
		var dir = (mouse_pos - player_pos).normalized()
		var angle = dir.angle()
		
		
		# Clamp angle between -45° and +20° (or 135° to 200° when mirrored)
		var min_angle = deg_to_rad(-45)
		var max_angle = deg_to_rad(20)
		
		#offset shield from character
		var offset = dir * 15
		
		#Place shield
		$Shield.global_position = player_pos + offset
		#Rotate shield
		$Shield.rotation = dir.angle()
	
	
# Called when there a input event
func _input(event):
	pass
		
	

#Got signal when left click
func _on_shield_shield_throw() -> void:
	#Get mouse global postion
	var mouse_pos = get_global_mouse_position()
	$Shield.is_thrown = true
	$Shield.throw_shield_at(mouse_pos)

#Got signal when shield touch any node2d
func _on_shield_body_entered(body: Node2D) -> void:
	$Shield.stop_shield()

#got signal when shield velocity = 0
func _on_shield_shield_stop() -> void:
	pass

#Got signal when right click
func _on_shield_shield_retrieve() -> void:
	var player_pos = $player.global_position
	$Shield.global_position = player_pos
	$Shield.is_thrown = false
