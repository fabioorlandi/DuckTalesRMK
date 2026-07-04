extends CharacterBody2D

signal invulnerability_ticks_finished
signal invulnerability_ticks_started

@export var canClimb: bool
@export var lastDir = "right"
@onready var attack_raycast = $AttackRayCast2D
@onready var interactive_pogo_shapecast = $InteractivePogoShapeCast2D
@onready var floor_pogo_shapecast = $FloorPogoShapeCast2D

@export var GRAVITY = 500.0
@export var SPEED := 100.0
@export var ROPE_SPEED := 50.0
@export var JUMP_FORCE := -225.0
@export var JUMP_CUT   := 0.25
@export var POGO_FORCE  := -280.0
@export var POGO_GRAVITY  := 600.0

var invulnerability_ticks = 0
var attacking: bool = false
var onPogo: bool = false
var onRope: bool = false
var ropeX: float

func _ready() -> void:
	invulnerability_ticks_started.connect(start_invulnerability)
	invulnerability_ticks_finished.connect(end_invulnerability)

func _process(delta: float) -> void:
	if lastDir == "left":
		$AnimatedSprite2D.flip_h = true
		attack_raycast.scale.x = scale.y * -1
	elif lastDir == "right":
		$AnimatedSprite2D.flip_h = false
		attack_raycast.scale.x = scale.y * 1
	
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
	
func get_damage_collision_with_enemy():
	var is_colliding = self.interactive_pogo_shapecast.is_colliding()
	if not is_colliding:
		return false
	
	var collider_interative = self.interactive_pogo_shapecast.get_collider(0)
	if onPogo and collider_interative and collider_interative.is_in_group("Inimigos"):
		return false
	
	var collision = self.get_last_slide_collision()
	if collision:
		var collider = collision.get_collider() as PhysicsBody2D
		if collider:
			return collider.is_in_group("Inimigos")

func start_invulnerability(ticks: int):
	invulnerability_ticks = ticks
	
	var enemies = get_tree().get_nodes_in_group("Inimigos")
	for enemy in enemies:
		self.add_collision_exception_with(enemy)

func end_invulnerability():
	var enemies = get_tree().get_nodes_in_group("Inimigos")
	for enemy in enemies:
		self.remove_collision_exception_with(enemy)
