extends Node

@onready var bgm_streamer : AudioStreamPlayer = $BackgroundMusic

func stop_background_music():
	bgm_streamer.stop()
	bgm_streamer.stream = null

func play_background_music(stream: AudioStream, loop_music: bool = true) -> void:
	if bgm_streamer.stream == stream and bgm_streamer.playing:
		return

	bgm_streamer.stream = stream
	bgm_streamer.play()
	
	if bgm_streamer.finished.is_connected(restart_background_music):
		bgm_streamer.finished.disconnect(restart_background_music)

	if loop_music:
		bgm_streamer.finished.connect(restart_background_music.bind(stream))
	
func restart_background_music(stream: AudioStream):
	play_background_music(stream)

func play_sound_effect(stream: AudioStream, allow_multiples: bool = true, bus: String = "Master") -> void:
	var existing_player: AudioStreamPlayer = null
	for child in get_children():
		if child is AudioStreamPlayer and  child != bgm_streamer and child.stream == stream:
			existing_player = child
			break
	
	if existing_player:
		if existing_player.playing:
			if allow_multiples:
				pass
			else:
				return
		else:
			existing_player.play()
			return
	
	var new_sfx := AudioStreamPlayer.new()
	new_sfx.stream = stream
	new_sfx.bus = bus
	new_sfx.finished.connect(destroy_stream_player.bind(new_sfx))
	add_child(new_sfx)
	new_sfx.play()

func destroy_stream_player(stream_player: AudioStreamPlayer) -> void:
	stream_player.queue_free()
