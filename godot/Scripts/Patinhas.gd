extends CharacterBody2D

@export var canClimb: bool
@export var lastDir = "right"
@onready var attack_raycast = $AttackRayCast2D
@onready var pogo_raycast = $PogoRayCast2D

var attacking: bool = false
var onRope: bool = false
var ropeX: float

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
	
