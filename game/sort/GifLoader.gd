extends TextureRect

func load_gif(path : String) -> bool:
	var loader : GIFLoader = GIFLoader.new()
	loader.load_gif(path)
	
	texture = loader.create_texture()

	return true
