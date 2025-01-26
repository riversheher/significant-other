extends AudioStreamPlayer

const default_music: AudioStream = preload("res://Assets/Music/Lost City.ogg")
const default_playlist: AudioStreamPlaylist = preload("res://Assets/Music/Default_Playlist.tres")
const door_close: AudioStream = preload("res://Assets/SFX/DoorClose.wav")
const door_open: AudioStream = preload("res://Assets/SFX/DoorOpen.wav")

func _play_music(music: AudioStream, volume: float = -5.0) -> void:
	if stream == music:
		if self.is_playing():
			return
		
	stream = music
	volume_db = volume
	self.play()
	
	
func _play_default_music() -> void:
	default_music.set_loop(true)
	_play_music(default_music)
	
func _play_default_playlist() -> void:
	default_playlist.set_loop(true)
	_play_music(default_playlist)

# Sound Effects
func play_FX(audio: AudioStream, volume: float = 0.0) -> void:
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = audio
	fx_player.volume_db = volume
	fx_player.name = "FX_PLAYER"
	
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	
	fx_player.queue_free()
	
func play_door_open(volume: float = -2.0) -> void:
	play_FX(door_open, volume)
	
func play_door_close(volume: float = -2.0) -> void:
	play_FX(door_close, volume)
	
