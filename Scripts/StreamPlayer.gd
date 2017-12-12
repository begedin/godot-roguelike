extends StreamPlayer

func _ready():
	self.set_stream(preload('res://Audio/music.ogg'))
	self.set_loop(true)
	self.play()
