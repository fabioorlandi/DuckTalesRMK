extends Camera2D

@export var player: CharacterBody2D
@export var speed := 5.0

var isFixedCamera:bool
var onTransition: bool = false

@export var minX: float
@export var maxX: float

@export var fixedX: float

@export var floorY: float = 312.0

@export var screenLayer: int

func _ready():
	isFixedCamera = false

func _process(delta):
	CheckMinMax()
	
	if player:
		# Camera follow in X
		if isFixedCamera == false and onTransition == false:
			if player.global_position.x < minX:
				global_position.x = minX
			elif player.global_position.x > maxX:
				global_position.x = maxX
			else:
				global_position.x = player.global_position.x
		elif isFixedCamera == true:
			global_position.x = fixedX
		
		# Camera follow in Y
		if onTransition == true:
			global_position.y = move_toward(global_position.y, floorY, speed * delta)
			if global_position.y == floorY:
				onTransition = false
				floorY = global_position.y
				isFixedCamera = false

func CheckMinMax() -> void:
	match floorY:
		-648.0:
			minX = 384.0
			maxX = 1142.0
		-408.0:
			if screenLayer == 1:
				minX = 384.0
				maxX = 896.0
			elif screenLayer == 2:
				minX = 1408.0
				maxX = 1920.0
			elif screenLayer == 3:
				minX = 1408.0
				maxX = 1408.0
		-168.0:
			if screenLayer == 1:
				minX = 384.0
				maxX = 384.0
			elif screenLayer == 2:
				minX = 640.0
				maxX = 1920.0
		72.0:
			if screenLayer == 1:
				minX = 384.0
				maxX = 384.0
			elif screenLayer == 2:
				minX = 640.0
				maxX = 1920.0
		312.0: 
			minX = 128.0
			maxX = 1920.0
		543.0:
			minX = 1152.0
			maxX = 1920.0
		
func TransitionCam(posUp: float, posDown: float, layer: int, block: bool) -> void:
	var shouldTransition := false
	
	if floorY == posUp:
		floorY = posDown
		shouldTransition = true
	elif floorY == posDown and not block:
		floorY = posUp
		shouldTransition = true
	
	if not shouldTransition:
		return  # bloqueado (ou nenhum dos dois bate) -> não faz nada
	
	if layer != 0:
		screenLayer = layer
	
	isFixedCamera = true
	onTransition = true
