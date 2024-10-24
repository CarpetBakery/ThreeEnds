extends AudioStreamPlayer

## Global music manager (can play across scenes)

func playMusic(audioStream: AudioStream) -> void:
	if stream == audioStream:
		return
	stream = audioStream
	play()
