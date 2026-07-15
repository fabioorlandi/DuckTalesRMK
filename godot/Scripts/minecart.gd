extends CharacterBody2D

@export var patinhas: CharacterBody2D

var shake_tween: Tween
var moving: bool
var ejecting_player: bool
signal free_on_death_area

func _ready() -> void:
	free_on_death_area.connect(queue_free_minecart)
	moving = false
	start_shake()

func _physics_process(delta: float) -> void:
	if moving and patinhas:
		if patinhas.get_node("CrouchCollisionShape2D").disabled:
			var lastCollision = patinhas.get_last_slide_collision()
		
			if lastCollision:
				var collider = lastCollision.get_collider()
				if (patinhas.is_on_ceiling() or patinhas.is_on_wall())\
					and collider is TileMapLayer:
					
					var currentState = patinhas.get_node("FSM").current_state
					if not ejecting_player:
						ejecting_player = true
						currentState.transitioned.emit(currentState, "damage")
		
		if is_on_floor():
			velocity.x = patinhas.SPEED * -1
		else:
			velocity.x = 0
			velocity.y += patinhas.GRAVITY * delta
	else:
		velocity.x = 0
			
	move_and_slide()

func start_shake() -> void:
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
	
	shake_tween = create_tween()
	var start_y = position.y
	
	shake_tween.tween_property(self, "position:y", start_y - 1, 0.1)
	shake_tween.tween_property(self, "position:y", start_y, 0.1)
	shake_tween.set_loops()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Patinhas"):
		ejecting_player = false
		patinhas = body
		moving = true
		$Area2D.monitoring = false
		if shake_tween and shake_tween.is_valid():
			shake_tween.kill()
			shake_tween = null

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Patinhas"):
		ejecting_player = true
		$Area2D.monitoring = true

func queue_free_minecart():
	moving = false
	$Area2D.monitoring = false
	$AnimatedSprite2D.visible = false
	$CollisionPolygon2D.disabled = true
