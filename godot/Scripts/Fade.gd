extends Node2D

@onready var player = $"../Patinhas"

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	fade_out(1.0)
	await get_tree().create_timer(1.0).timeout

func _process(delta: float) -> void:
	var camera = get_tree().get_first_node_in_group("Camera")
	
	if camera:
		global_position = camera.global_position

func fade_out(duracao: float = 0.5):
	var tween = create_tween()
	# Transiciona o canal Alpha (a) do modulate deste nó (raiz) para 0 (invisível)
	# Como este nó é o pai de todos, tudo abaixo dele vai sumir junto!
	tween.tween_property(self, "modulate:a", 0.0, duracao)

func fade_in(duracao: float = 0.5):
	var tween = create_tween()
	# Transiciona o canal Alpha para 1 (totalmente visível)
	tween.tween_property(self, "modulate:a", 1.0, duracao)
	
func DoFadeIn(inGame: bool) -> void:
	get_tree().paused = !get_tree().paused
	await get_tree().create_timer(0.5).timeout
	fade_in(0.5)
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = !get_tree().paused
	if inGame:
		$"..".ResetPlayer()
	
func DoFadeOut() -> void:
	get_tree().paused = !get_tree().paused
	await get_tree().create_timer(0.5).timeout
	fade_out(0.5)
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = !get_tree().paused

func DoFadeInOutTeleport(positionTo: Vector2, floor: float, screenLayer: int) -> void:
	get_tree().paused = !get_tree().paused
	fade_in(0.5)
	await get_tree().create_timer(0.6).timeout
	if player:
		player.Teleport(positionTo, floor, screenLayer)
	await get_tree().create_timer(0.3).timeout
	fade_out(0.5)
	await get_tree().create_timer(0.6).timeout
	get_tree().paused = !get_tree().paused
	
	AudioManager.process_mode = Node.PROCESS_MODE_INHERIT

func DoFadeOutToScene(scene: String) -> void:
	get_tree().paused = !get_tree().paused
	fade_in(0.5)
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file(scene)
