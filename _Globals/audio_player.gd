extends AudioStreamPlayer

const default_music: AudioStream = preload("res://Assets/Music/Lost City.ogg")

func _play_music(music: AudioStream, volume: float = 0.0) -> void:
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
	
func _play_default_music() -> void:
	_play_music(default_music)


func play_FX(audio: AudioStream, volume: float = 0.0) -> void:
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = audio
	fx_player.volume_db = volume
	fx_player.name = "FX_PLAYER"
	
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	
	fx_player.queue_free()
