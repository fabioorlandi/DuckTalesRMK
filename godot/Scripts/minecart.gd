extends CharacterBody2D

@export var patinhas: CharacterBody2D

var shake_tween: Tween
var moving: bool
signal free_on_death_area

func _ready() -> void:
	free_on_death_area.connect(queue_free_minecart)
	moving = false
	start_shake()

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if moving and patinhas:
		if is_on_floor():
			velocity.x = -1 * patinhas.SPEED
		else:
			velocity.x = 0
			velocity.y += patinhas.GRAVITY * delta

func start_shake() -> void:
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
	
	shake_tween = create_tween()
	var start_y = position.y
	
	shake_tween.tween_property(self, "position:y", start_y - 1, 0.1)
	shake_tween.tween_property(self, "position:y", start_y, 0.1)
	shake_tween.set_loops()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if moving:
		return
	
	if body.is_in_group("Patinhas"):
		patinhas = body
		moving = true
		if shake_tween and shake_tween.is_valid():
			shake_tween.kill()
			shake_tween = null

func queue_free_minecart():
	queue_free()
