extends CharacterBody2D

signal invulnerability_ticks_finished
signal invulnerability_ticks_started
signal take_damage
signal patinhas_death

@export var canClimb: bool
@export var lastDir = "right"
@onready var attack_raycast = $AttackRayCast2D
@onready var interactive_pogo_shapecast = $InteractivePogoShapeCast2D
@onready var floor_pogo_shapecast = $FloorPogoShapeCast2D

@export var GRAVITY = 500.0
@export var SPEED := 110.0
@export var ROPE_SPEED := 50.0
@export var JUMP_FORCE := -225.0
@export var JUMP_CUT   := 0.25
@export var POGO_FORCE  := -280.0
@export var POGO_GRAVITY  := 600.0

@onready var health = $"../Camera2D/UI".health

var invulnerability_ticks = 0
var kill_enemies_during_invulnerability = false
var attacking: bool = false
var onPogo: bool = false
var onRope: bool = false
var takingDamage: bool = false
var collisionWithEnemy: bool = false
var ropeX: float

func _ready() -> void:
	invulnerability_ticks_started.connect(start_invulnerability)
	invulnerability_ticks_finished.connect(end_invulnerability)
	take_damage.connect(compute_hit)
	patinhas_death.connect(on_die)

func _process(delta: float) -> void:
	if lastDir == "left":
		$AnimatedSprite2D.flip_h = true
		attack_raycast.scale.x = scale.y * -1
	elif lastDir == "right":
		$AnimatedSprite2D.flip_h = false
		attack_raycast.scale.x = scale.y * 1
	
	if Input.is_action_just_pressed("1"):
		Teleport(Vector2(176,345), 312)
	if Input.is_action_just_pressed("2"):
		Teleport(Vector2(1875,574), 543)
	if Input.is_action_just_pressed("3"):
		Teleport(Vector2(1537,-115), -168)
	if Input.is_action_just_pressed("4"):
		Teleport(Vector2(1568,-355), -408)
	if Input.is_action_just_pressed("5"):
		Teleport(Vector2(1043,-726), -648)

func _physics_process(delta: float) -> void:
	if invulnerability_ticks > 0:
		if invulnerability_ticks % 2 == 0:
			self.modulate.a = 0
		else:
			self.modulate.a = 1
	
		invulnerability_ticks -= 1
	if invulnerability_ticks <= 0:
		self.modulate.a = 1
		invulnerability_ticks = 0
		
		self.emit_signal("invulnerability_ticks_finished")

func animate(animation: String):
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.play()

func SetClimb(status: bool, posX: float) -> void:
	canClimb = status
	ropeX = posX

func Teleport(pos : Vector2, floor: float) -> void:
	self.global_position = pos
	var temp = Vector2(pos.x , floor)
	$"../Camera2D".futurePos = floor
	$"../Camera2D".fixed_y = floor
	$"../Camera2D".global_position = temp
	$"../Camera2D".follow_x = true

func on_die():
	$"../Camera2D".follow_x = false
	$"../Camera2D".follow_y = false
	
	self.emit_signal("invulnerability_ticks_started", 9999)
	$CollisionShape2D.disabled = true

	var tween = create_tween()
	var death_recoil = self.position + Vector2(50, 150)\
		if self.lastDir == "left"\
		else self.position + Vector2(-50, 150)
	
	var start_pos = self.position
	var end_pos = death_recoil
	var height = 60
	
	tween.tween_method(
		func(progress):
			var x = lerp(start_pos.x, end_pos.x, progress)
			var y = lerp(start_pos.y, end_pos.y, progress) - height * sin(progress * PI)
			self.position = Vector2(x, y),
		0.0, 1.0, 0.75
	)

	self.animate(&"Morte")
	await $AnimatedSprite2D.animation_finished

	Input.action_press("m")

func start_invulnerability(ticks: int, allow_kill_enemies: bool = false):
	invulnerability_ticks = ticks
	
	kill_enemies_during_invulnerability = allow_kill_enemies

	var enemies = get_tree().get_nodes_in_group("Inimigos")
	for enemy in enemies:
		self.add_collision_exception_with(enemy)

func end_invulnerability():
	$CollisionArea2D.monitoring = true
	
	var enemies = get_tree().get_nodes_in_group("Inimigos")
	for enemy in enemies:
		self.remove_collision_exception_with(enemy)
		
func compute_hit():
	$"../Camera2D/UI".CauseDamage()
	health = $"../Camera2D/UI".health

	self.emit_signal("invulnerability_ticks_started", 80)

	var tween = create_tween()
	var damage_recoil = self.position + Vector2(20, -20)\
		if self.lastDir == "left"\
		else self.position + Vector2(-20, -20)
	tween.tween_property(self, "position", damage_recoil, 0.15)
	
	self.animate(&"Dano")
	await $AnimatedSprite2D.animation_finished

func _on_collision_area_2d_body_entered(body: Node2D) -> void:
	if body is PhysicsBody2D and body.is_in_group("Inimigos") and "can_hit_patinhas" in body and body.can_hit_patinhas:
		if self.invulnerability_ticks == 0:
			$CollisionArea2D.monitoring = false
			self.takingDamage = true
			self.collisionWithEnemy = true
		elif self.invulnerability_ticks > 0 and self.kill_enemies_during_invulnerability:
			body.emit_signal("die_on_collision")

func _on_collision_area_2d_body_exited(body: Node2D) -> void:
	if body is PhysicsBody2D and body.is_in_group("Inimigos"):
		self.collisionWithEnemy = false
