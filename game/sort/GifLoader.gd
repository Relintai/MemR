extends TextureRect

func load_gif(path : String) -> bool:
	var reader = GifReader.new()
	reader.filter = false
	reader.mipmaps = false
	
	var tex : AnimatedTexture = reader.read(path)
	
	if tex == null:
		return false
	
	texture = tex
	
	return true
