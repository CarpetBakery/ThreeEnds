extends AudioStreamPlayer

func playMusic(audioStream: AudioStream) -> void:
	if stream == audioStream:
		return
	stream = audioStream
	play()
