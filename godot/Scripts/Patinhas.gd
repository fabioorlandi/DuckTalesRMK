extends CharacterBody2D

signal invulnerability_ticks_finished
signal invulnerability_ticks_started
signal take_damage
signal patinhas_death
signal on_death_area

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
var dead: bool
var dead_on_death_area: bool

func _ready() -> void:
	invulnerability_ticks_started.connect(start_invulnerability)
	invulnerability_ticks_finished.connect(end_invulnerability)
	take_damage.connect(compute_hit)
	patinhas_death.connect(on_die)
	on_death_area.connect(on_die_death_area)

func _process(delta: float) -> void:
	if lastDir == "left":
		$AnimatedSprite2D.flip_h = true
		attack_raycast.scale.x = scale.y * -1
	elif lastDir == "right":
		$AnimatedSprite2D.flip_h = false
		attack_raycast.scale.x = scale.y * 1
	
	if Input.is_action_just_pressed("1"):
		Teleport(Vector2(62,370), 312, 0)
	if Input.is_action_just_pressed("2"):
		Teleport(Vector2(1875,578), 543, 2)
	if Input.is_action_just_pressed("3"):
		Teleport(Vector2(1540,-110), -168, 2)
	if Input.is_action_just_pressed("4"):
		Teleport(Vector2(1101,-655), -648, 1)
	if Input.is_action_just_pressed("5"):
		Teleport(Vector2(1966,-351), -408, 2)

func _physics_process(delta: float) -> void:
	if dead or dead_on_death_area:
		$CollisionShape2D.disabled = true
		$CrouchCollisionShape2D.disabled = true

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

func Teleport(pos : Vector2, floor: float, layer: int) -> void:
	self.global_position = pos
	var temp = Vector2(pos.x , floor)
	$"../Camera2D".global_position = temp
	$"../Camera2D".floorY = floor
	$"../Camera2D".screenLayer = layer

func on_die():
	dead = true
	var wait_timer_to_reset = 0
	
	if $"../Camera2D/UI".lifes <= 0:
		wait_timer_to_reset = 3
		AudioManager.play_background_music(load("res://Sounds/13_-_DuckTales_-_NES_-_Game_Over.ogg"), false)
	else:
		wait_timer_to_reset = 2
		AudioManager.play_background_music(load("res://Sounds/12_-_DuckTales_-_NES_-_Dead.ogg"), false)
	
	if not dead_on_death_area:
		self.emit_signal("invulnerability_ticks_started", 9999)
		var tween = create_tween()
		var death_recoil = self.position + Vector2(50, 250)\
			if self.lastDir == "left"\
			else self.position + Vector2(-50, 250)
		
		var start_pos = self.position
		var end_pos = death_recoil
		var height = 100
		
		tween.tween_method(
			func(progress):
				var x = lerp(start_pos.x, end_pos.x, progress)
				var y = lerp(start_pos.y, end_pos.y, progress) - height * sin(progress * PI)
				self.position = Vector2(x, y),
			0.0, 1.0, 1
		)
		self.animate(&"Morte")
		await $AnimatedSprite2D.animation_finished
	else:
		var death_area_position = self.position.y + 200
		var start_y = self.position.y
		var tween = create_tween()
		
		tween.tween_method(
			func(progress):
				self.position.y = lerp(start_y, death_area_position, progress),
			0.0, 1.0, 0.75
		)
	await get_tree().create_timer(wait_timer_to_reset).timeout
	
	$"../Fade".DoFadeIn(true)
	queue_free()
	
func on_die_death_area():
	dead_on_death_area = true
	$FSM.on_child_transition($FSM.current_state, "death")

func start_invulnerability(ticks: int, allow_kill_enemies: bool = false):
	if allow_kill_enemies:
		AudioManager.play_background_music(load("res://Sounds/09_-_DuckTales_-_NES_-_Magic_Coin.ogg"))
	
	invulnerability_ticks = ticks
	
	kill_enemies_during_invulnerability = allow_kill_enemies

	var enemies = get_tree().get_nodes_in_group("Inimigos")
	for enemy in enemies:
		self.add_collision_exception_with(enemy)

func end_invulnerability():
	if not dead :
		if not $"../Camera2D".onBoss:
			AudioManager.play_background_music(load(get_parent().currentLevelSong))
	
	$CollisionArea2D.monitoring = true
	
	var enemies = get_tree().get_nodes_in_group("Inimigos")
	for enemy in enemies:
		self.remove_collision_exception_with(enemy)
		
func compute_hit():
	$"../Camera2D/UI".CauseDamage()
	health = $"../Camera2D/UI".health

	self.emit_signal("invulnerability_ticks_started", 80)
	AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (11).wav"), false)

	var tween = create_tween()
	var damage_recoil = self.position + Vector2(20, -20)\
		if self.lastDir == "left"\
		else self.position + Vector2(-20, -20)
	tween.tween_property(self, "position", damage_recoil, 0.15)
	
	self.animate(&"Dano")
	await $AnimatedSprite2D.animation_finished

func _on_collision_area_2d_body_entered(body: Node2D) -> void:
	if body is PhysicsBody2D\
		and body.is_in_group("Inimigos")\
		and "can_hit_patinhas" in body\
		and body.can_hit_patinhas:
		if self.invulnerability_ticks == 0:
			$CollisionArea2D.monitoring = false
			self.takingDamage = true
			self.collisionWithEnemy = true
		elif self.invulnerability_ticks > 0 and self.kill_enemies_during_invulnerability:
			body.emit_signal("die_on_collision")

func _on_collision_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	
	if parent is PhysicsBody2D and parent.is_in_group("Inimigos")\
		and "can_area_hit_patinhas" in parent\
		and parent.can_area_hit_patinhas\
		and "can_hit_patinhas" in parent\
		and parent.can_hit_patinhas:
		if self.invulnerability_ticks == 0:
			$CollisionArea2D.monitoring = false
			self.takingDamage = true
			self.collisionWithEnemy = true
		elif self.invulnerability_ticks > 0 and self.kill_enemies_during_invulnerability:
			parent.emit_signal("die_on_collision")

func _on_collision_area_2d_body_exited(body: Node2D) -> void:
	if body is PhysicsBody2D and body.is_in_group("Inimigos"):
		self.collisionWithEnemy = false

func _on_collision_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is PhysicsBody2D and area.get_parent().is_in_group("Inimigos"):
		self.collisionWithEnemy = false
